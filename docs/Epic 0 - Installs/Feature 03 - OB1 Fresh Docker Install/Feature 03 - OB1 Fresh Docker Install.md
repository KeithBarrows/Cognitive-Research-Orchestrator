# Feature 03 — OB1 Fresh Docker Install

*(Part of Epic 0 — Installs. See `../../phase-0-plan.md` for the full
Epic.)*

## Install

OB1, fresh Docker install — the real blocker flagged when Epic 1 was
first reviewed: the exact Docker image/compose setup and the local
instance's actual REST API surface are both unverified. This is where
that gets resolved. **Not reusing** the existing `ob1-local` Supabase
instance — it's not reusable as-is (crashed Edge Runtime, shared
Postgres with the weather-station project — see `../../../CURRENT.md`'s
OB1 status note); this is a fresh install, not a repair.

## Test

- Install it, then confirm live what its REST endpoints actually
  look like — the same way TheBrain's and Plane's were confirmed
  live before being written into the schema. This is genuinely
  unknown until this Feature actually happens.
- The local OB1 Docker container is running and reachable.
- Confirm it uses its **own** Postgres, not shared with `cro_index`
  (Feature 02) or anything else.

## Candidates found 2026-11-05 (upstream docs, read live)

Source: `github.com/NateBJones-Projects/OB1`, `main`. The newest
commit visible in the cached pages was 2026-09-10, so later changes
may be missing. Re-check before installing. The old fork at
`D:\Repos\KeithBarrows\OB1` was checked on 2026-11-05 and is current
(HEAD `238df6c`, 2026-09-10).

Hard rule (user, 2026-11-05): OB1 runs in Docker on the laptop and
is never given cloud access for anyone. Nothing, including
embeddings, may call OpenRouter or any other cloud service.

- **Base: `recipes/local-brain-no-mcp`.** Official Supabase
  docker-compose stack plus an Ollama sidecar for local embeddings.
  README: "Nothing leaves the LAN." Endpoints: POST
  `/functions/v1/capture`, POST `/functions/v1/search`, GET
  `/functions/v1/list`. No update, no delete (Supabase Studio is the
  manual route). `EMBED_DIM` cannot change later without wiping the
  volume. Needs Docker 24+ and Compose v2.20+.
- **REST with update/delete: `integrations/rest-api`.** `PUT
  /thought/:id`, `DELETE /thought/:id`, header-only keys,
  single-tenant. A Supabase Edge Function. Needs an LLM key
  (OpenRouter, OpenAI or Anthropic); no local-model route is
  documented. README does not say whether delete is hard or soft.
- **`integrations/enhanced-mcp`.** 13 tools including
  `update_thought`; no delete (waits for a `deleted_at` column and
  `restore_thought`). MCP only. Open upstream bugs: #506
  (`update_thought` uncallable), #490 (search returns zero rows,
  captures lose embeddings), #413 (thought ID type mismatch).
- **`integrations/delete-thought-mcp`.** `delete_thought(id)`, a
  hard delete. Optional `schemas/thought-audit` keeps prior content.
- **`integrations/update-thought-mcp`.** `update_thought`; content
  overwrite with re-embed, metadata merge.
- Maintainer stance (PR #127, closed): "Depreciating and versioning
  in a database should be the priority, not deletion."

## Test (trial both, keep what works)

1. Stand up `local-brain-no-mcp`. Confirm no outbound cloud calls.
2. Try `integrations/rest-api` on that stack with Ollama behind its
   OpenAI-compatible base URL instead of a cloud key. Unverified
   whether this works. If it does not, record why, and decide
   between a small patch and a custom thin REST layer.
3. Confirm update and delete work, and whether delete is hard.
4. Pick the embedding model and dimension BEFORE first capture.
5. Confirm OB1 uses its own Postgres, not shared with `cro_index`.

## Result

**Done 2026-11-05.** All 12 User Stories in this folder are done.
Setup lives in `src\Infra\03a-ob1-local-brain` (the upstream
`local-brain-no-mcp` recipe with our changes, listed in
`UPSTREAM.txt`), started by `src\Infra\up.cmd`. Data is in
`D:\Data\CRO\ob1-db` and `D:\Data\CRO\ollama`. All services publish on
127.0.0.1 only. OB1 update and delete come from our own `update` and
`delete` Edge Functions (upstream `rest-api` was ruled out). The
planned `03b` folder was not needed.
