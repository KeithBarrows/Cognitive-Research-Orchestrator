// PUT /functions/v1/update
//
// Body:
//   { id: string (uuid), content?: string, metadata?: object }
//
// CRO addition (not in upstream). New content is re-embedded through the
// local Ollama sidecar and the fingerprint is recomputed (same
// normalization as upsert_thought). Metadata is merged into the existing
// metadata, like upsert_thought does.

import { corsHeaders, jsonResponse } from "../_shared/cors.ts";
import { embed, EmbedError } from "../_shared/embed.ts";
import { db } from "../_shared/db.ts";

async function fingerprint(text: string): Promise<string> {
  const norm = text.replace(/\s+/g, " ").trim().toLowerCase();
  const buf = await crypto.subtle.digest("SHA-256", new TextEncoder().encode(norm));
  return Array.from(new Uint8Array(buf)).map((b) => b.toString(16).padStart(2, "0")).join("");
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response(null, { status: 204, headers: corsHeaders });
  if (req.method !== "PUT") return jsonResponse({ error: "method not allowed" }, 405);

  let body: { id?: unknown; content?: unknown; metadata?: unknown };
  try { body = await req.json(); } catch { return jsonResponse({ error: "body must be valid JSON" }, 400); }

  const id = typeof body.id === "string" ? body.id : "";
  if (!/^[0-9a-f-]{36}$/i.test(id)) return jsonResponse({ error: "id must be a uuid" }, 400);
  const content = typeof body.content === "string" ? body.content.trim() : undefined;
  const metadata = body.metadata && typeof body.metadata === "object" && !Array.isArray(body.metadata)
    ? body.metadata as Record<string, unknown> : undefined;
  if (content === "") return jsonResponse({ error: "content must be non-empty" }, 400);
  if (content === undefined && metadata === undefined) return jsonResponse({ error: "nothing to update" }, 400);

  const { data: existing, error: readErr } = await db.from("thoughts").select("metadata").eq("id", id).maybeSingle();
  if (readErr) return jsonResponse({ error: `read failed: ${readErr.message}` }, 500);
  if (!existing) return jsonResponse({ error: "not found" }, 404);

  const patch: Record<string, unknown> = {};
  if (content !== undefined) {
    try { patch.embedding = await embed(content); }
    catch (e) { if (e instanceof EmbedError) return jsonResponse({ error: e.message }, 502); throw e; }
    patch.content = content;
    patch.content_fingerprint = await fingerprint(content);
  }
  if (metadata !== undefined) patch.metadata = { ...(existing.metadata ?? {}), ...metadata };

  const { data, error } = await db.from("thoughts").update(patch).eq("id", id)
    .select("id, content_fingerprint").single();
  if (error) return jsonResponse({ error: `update failed: ${error.message}` }, error.code === "23505" ? 409 : 500);
  return jsonResponse({ ok: true, id: data.id, fingerprint: data.content_fingerprint }, 200);
});
