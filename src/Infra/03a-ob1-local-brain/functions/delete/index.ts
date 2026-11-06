// DELETE /functions/v1/delete?id=<uuid>
//
// CRO addition (not in upstream). Hard delete of one thought by id.

import { corsHeaders, jsonResponse } from "../_shared/cors.ts";
import { db } from "../_shared/db.ts";

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response(null, { status: 204, headers: corsHeaders });
  if (req.method !== "DELETE") return jsonResponse({ error: "method not allowed" }, 405);

  const id = new URL(req.url).searchParams.get("id") ?? "";
  if (!/^[0-9a-f-]{36}$/i.test(id)) return jsonResponse({ error: "id must be a uuid" }, 400);

  const { data, error } = await db.from("thoughts").delete().eq("id", id).select("id");
  if (error) return jsonResponse({ error: `delete failed: ${error.message}` }, 500);
  if (!data || data.length === 0) return jsonResponse({ error: "not found" }, 404);
  return jsonResponse({ ok: true, deleted: data[0].id }, 200);
});
