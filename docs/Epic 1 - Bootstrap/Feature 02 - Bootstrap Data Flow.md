# Feature 02 — Bootstrap Data Flow

*(Part of Epic 1 — Bootstrap. See `../phase-1-plan.md` for the full
Epic; see `../phase-roadmap.md` for the Plane EPIC/FEATURE/USER STORY
tagging convention this file is meant to seed.)*

## Scope

The core read, one direction only — diagrammed in
`../architecture/08-bootstrap-flow.mmd`:

- TheBrain is read once and feeds both `cro_index` and a new local OB1
  instance. TheBrain is never written back to in this phase.
- The existing cloud OB1's thoughts are read once and transferred into
  the new local OB1 (OB1-to-OB1, no TheBrain involved) via
  get-thoughts/save-thoughts calls. Exact tool names to confirm
  against the local instance's enhanced-mcp surface at implementation
  time — the cloud instance exposes list_thoughts/search_thoughts/
  capture_thought; the local one may differ.
- Install OB1 local via Docker as part of this Feature — the existing
  `ob1-local` Supabase instance is not reusable as-is (crashed Edge
  Runtime, shared Postgres with the weather-station project), this is
  a fresh install.
- Update the architecture documents/diagrams once the Docker install
  and transfer mechanism are actually implemented, so they match what
  runs rather than the planned version.

Depends on Epic 0 having installed OB1 local's Docker container
already — this Feature stands it up for real, Epic 0 only proved the
install path works.

## Schema touched

`thebrain_nodes`, `ob1_nodes`, `chunks` (with real 384-dim embeddings,
`ElBruno.LocalEmbeddings`, CPU-pinned), `edges` (walked from each
Thought's `/graph` response), `sync_state`.

## Dependency

Needs Feature 01 (Lookup-Table Resync) to have already run, so every
`thebrain_nodes` row has a valid `category_type_id` FK to resolve
against.

## Acceptance test

Content that exists only in TheBrain has a `thebrain_nodes` row, at
least one `chunks` row with a real 384-dim embedding, and (where
applicable) `edges` rows, each correctly linked back to its real
TheBrain Thought ID — checked by querying `cro_index` directly, not
through a search feature (Epic 2 doesn't exist yet). The local OB1
Docker container is running and reachable, and the thought count in
local OB1 matches the cloud source after transfer. `cro_index` can be
deleted and rebuilt from TheBrain + OB1 with zero data loss. Running
the bootstrap a second time against unchanged source data produces no
duplicate `cro_index` rows and no duplicate OB1 thoughts (upsert-by-
`source_id`, not blind insert).

## Not yet designed

The exact local-OB1 enhanced-mcp tool names (confirm at implementation
time against the live local instance, not assumed from the cloud
instance's surface).
