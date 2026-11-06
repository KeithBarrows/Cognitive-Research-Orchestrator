# Feature 02 — Bootstrap Data Flow

*(Part of Epic 1 — Bootstrap. See `../phase-1-plan.md` for the full
Epic; see `../phase-roadmap.md` for the Plane EPIC/FEATURE/USER STORY
tagging convention this file is meant to seed.)*

## Scope

The core read, one direction only — diagrammed in
`../architecture/08-bootstrap-flow.mmd`:

- TheBrain is read once and feeds both `cro_index` and a new local OB1
  instance. TheBrain is never written back to in this phase.
- **Deferred 2026-11-05 (user: ignore the cloud OB1 for now).** The
  existing cloud OB1's thoughts are read once and transferred into
  the new local OB1 (OB1-to-OB1, no TheBrain involved) via
  get-thoughts/save-thoughts calls. Exact tool names to confirm
  against the local instance's enhanced-mcp surface at implementation
  time — the cloud instance exposes list_thoughts/search_thoughts/
  capture_thought; the local one may differ.
- The local OB1 Docker install is **Epic 0's job** (`../Epic 0 -
  Installs/Feature 03 - OB1 Fresh Docker Install/Feature 03 - OB1
  Fresh Docker Install.md`), not this
  Feature's — corrected 2026-11-05. This Feature only writes to the
  already-running instance. The old `ob1-local` Supabase instance is
  not reusable (crashed Edge Runtime, shared Postgres with the
  weather-station project).
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
inside the trusted boundary). Rebuild safety is `../phase-1-plan.md`
test 1 and Feature 08. Running the bootstrap a second time against unchanged source data produces no
duplicate `cro_index` rows and no duplicate OB1 thoughts (upsert-by-
`source_id`, not blind insert).

## Not yet designed

The exact local-OB1 enhanced-mcp tool names (confirm at implementation
time against the live local instance, not assumed from the cloud
instance's surface).
