# Feature 02 — Dedicated Postgres with pgvector for cro_index

*(Part of Epic 0 — Installs. See `../phase-0-plan.md` for the full
Epic.)*

## Install

A Postgres container with the pgvector extension, **dedicated to
`cro_index`** — not shared with anything else. This matters
specifically because the *old* local OB1 instance failed partly
because it shared its Postgres with an unrelated weather-station
project (see `../../CURRENT.md`'s OB1 status note) — this is the same
mistake, not repeated. Also satisfies the already-settled decision
that `cro_index` storage stays separate from OB1-owned storage.

## Test

- pgvector extension is actually installed and enabled, not just the
  base Postgres image (`CREATE EXTENSION vector;` succeeds, or it's
  already present).
- The real `cro_index` schema from `../cro-index-schema.md` can be
  created against it — all 8 designed tables (`brains`,
  `thebrain_types`, `sensitivity_tiers`, `thebrain_nodes`, `ob1_nodes`,
  `plane_workitems`, `node_links`, `chunks`, `edges`, `sync_state`),
  plus a real `vector(384)` embedding insert and a similarity query
  against it.
- Confirmed **not** sharing a Postgres instance with OB1 (Feature 03)
  or anything else already running on the laptop.

## Not yet designed

Nothing specific to this Feature — the schema itself is fully settled
in `../cro-index-schema.md`. See Feature 07 for how CRO/AI tooling
actually connects to and tests this container via MCP.
