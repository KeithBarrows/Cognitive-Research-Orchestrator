# Feature 02 — Bootstrap Data Flow

*(Part of Epic 1 — Bootstrap. See `../../phase-1-plan.md` for the full
Epic; see `../../phase-roadmap.md` for the Plane EPIC/FEATURE/USER STORY
tagging convention this file is meant to seed.)*

## Scope

The core read, one direction only — diagrammed in
`../../architecture/08-bootstrap-flow.mmd`:

- TheBrain is read once and feeds both `cro_index` and a new local OB1
  instance. TheBrain is never written back to in this phase.
- **Deferred 2026-11-05 (user: ignore the cloud OB1 for now).** The
  existing cloud OB1's thoughts are read once and transferred into
  the new local OB1 (OB1-to-OB1, no TheBrain involved). The write side
  is the local REST API below. How the cloud thoughts are read is not
  designed: the cloud instance exposes MCP tools (list_thoughts,
  search_thoughts, capture_thought), not the local REST surface.
- The local OB1 Docker install is **Epic 0's job** (`../../Epic 0 -
  Installs/Feature 03 - OB1 Fresh Docker Install/Feature 03 - OB1
  Fresh Docker Install.md`), not this
  Feature's — corrected 2026-11-05. This Feature only writes to the
  already-running instance. The old `ob1-local` Supabase instance is
  not reusable (crashed Edge Runtime, shared Postgres with the
  weather-station project).
- **How this Feature talks to the local OB1 (added 2026-11-06).**
  Through our own REST functions at
  `http://127.0.0.1:8000/functions/v1/`: `capture` (POST), `search`
  (POST), `list` (GET), `update` (PUT) and `delete` (DELETE
  `?id=<uuid>`). Epic 0 Feature 03 Stories 07 and 11 tested all five.
  Auth is the generated `ANON_KEY` sent as the `apikey` and
  `Authorization: Bearer` headers, read from User Secrets, never from
  a repo file. The C# REST client that makes these calls is part of
  this Feature's scope, because Epic 0 is installs only and holds no
  CRO code. `capture` takes caller-supplied metadata and does no LLM
  extraction. The local OB1 has no MCP connection; whether to add a
  thin MCP wrapper for Claude Code is optional and is decided after
  the C# client exists.
- Update the architecture documents/diagrams once the Docker install
  and transfer mechanism are actually implemented, so they match what
  runs rather than the planned version.

Depends on Epic 0 having installed and tested OB1 local's Docker
container (Epic 0 Feature 03) — corrected 2026-11-05: this Feature
does not install it.

## Schema touched

`thebrain_nodes`, `ob1_nodes`, `chunks` (with real 768-dim embeddings,
`nomic-embed-text` via local Ollama), `edges` (walked from each
Thought's `/graph` response), `sync_state`.

## Dependency

Needs Feature 01 (Lookup-Table Resync) to have already run, so every
`thebrain_nodes` row has a valid `category_type_id` FK to resolve
against.

## Acceptance test

Content that exists only in TheBrain has a `thebrain_nodes` row, at
least one `chunks` row with a real 768-dim embedding, and (where
applicable) `edges` rows, each correctly linked back to its real
TheBrain Thought ID — checked by querying `cro_index` directly, not
through a search feature (Epic 2 doesn't exist yet). The local OB1
Docker container is running and reachable. Every TheBrain Thought read
has at least one `node_links` row to an `ob1_nodes` row (OB1 universal
coverage). Every OB1 thought read has an `ob1_nodes` row and `chunks`.
OB1 thoughts with no TheBrain or Plane link are expected (OB1 holds
some business-process information that exists nowhere else) and are
not errors. No count match between sources is required or tested
(changed 2026-11-05). Every node's full text is written to OB1,
`restricted` content included (decided 2026-11-05; OB1 is local-only
inside the trusted boundary). Rebuild safety is `../../phase-1-plan.md`
test 1 and Feature 08. Running the bootstrap a second time against unchanged source data produces no
duplicate `cro_index` rows and no duplicate OB1 thoughts (upsert-by-
`source_id`, not blind insert).

## Chunking rule (added 2026-11-07)

The embedding model reads at most 2,048 tokens and silently drops the
rest (tested 2026-11-07; see `../../Notes and Findings.md`). So Pass 2
cuts each Note and file list into chunks of about 1,000-1,500
characters at natural breaks, writes one `chunks` row per piece with
its own vector, and starts every chunk with the Thought's name. OB1
still gets one entry per Thought with the full text (the 2026-11-05
rule); its vector covers only the opening. Pass 2 logs any text over
the safe length instead of letting it be cut silently. The exact chunk
size is confirmed at implementation time against real Notes.

## Not yet designed

- How the cloud OB1's thoughts are read for the deferred transfer
  (the cloud side is MCP only).
- Whether Claude Code also gets a local OB1 MCP wrapper over the REST
  functions. Optional, decided after the C# client exists.
- The exact request and response shapes the C# client relies on are
  recorded in Epic 0 Feature 03 Story 07. Confirm them against the
  live local instance at implementation time.
