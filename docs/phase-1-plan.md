# Phase 1 Plan — Bootstrap

**Status:** Still needing approval (as of 2026-11-04). `CURRENT.md`'s
"Next checkpoint" has the review this is waiting on. See
`docs/phase-roadmap.md` for how this fits with Phases 2–5.

## 1. Scope

**A single run, not a continuous process.** Read TheBrain once, raw.
For what's read: create or update matching entries in OB1 and in
`cro_index`. Flag — never act on — Thoughts/notes that might need
moving or reorganizing (the actual move is Phase 4). Once done, this
run's result sits in reserve as the base for a future resync, rather
than running again on its own.

Concretely:

- TheBrain is read once and feeds both `cro_index` and a new local OB1
  instance — one direction only, TheBrain is never written back to in
  this phase.
- The existing cloud OB1's thoughts are read once and transferred into
  the new local OB1 (OB1-to-OB1, no TheBrain involved).
- Flagging: CRO records a `node_links` row with `link_type =
  'duplicate_candidate'` (see `docs/cro-index-schema.md`) wherever it
  finds two records that look like the same real-world thing — e.g.
  the confirmed-live case of "Kittery" existing as two separate,
  unlinked TheBrain Thoughts (Growth and Filing Cabinet). This is a
  flag only. CRO never auto-merges, and no actual move happens in this
  phase — that's Phase 4.
- Searching/looking things up is explicitly **not** part of this
  phase — that's Phase 2.

## 2. Dependency: the bootstrap data flow

Diagrammed in `docs/architecture/08-bootstrap-flow.mmd`. This flow
*is* Phase 1 — there's no separate "feature" layered on top of it.

Bootstrap sub-steps, made explicit on approval (2026-10-20):

- Install OB1 local via Docker. The existing `ob1-local` Supabase
  instance is not reusable as-is (crashed Edge Runtime, shared
  Postgres with the weather-station project — see `CURRENT.md`'s OB1
  status note); this is a fresh install, not a repair.
- Transfer cloud OB1's thoughts into the new local OB1 by reading each
  thought from the cloud instance and writing it to the local instance
  (get-thoughts / save-thoughts calls). Exact tool names to confirm
  against the local instance's enhanced-mcp surface at implementation
  time — the cloud instance exposes list_thoughts/search_thoughts/
  capture_thought; the local one may differ.
- Update the architecture documents and diagrams (`docs/README.md`,
  `docs/architecture/*.mmd`) once the Docker install and transfer
  mechanism are implemented, so the diagrams match what actually runs
  rather than the planned version.

## 3. Schema touched this phase

`brains`, `thebrain_types`, `sensitivity_tiers`, `thebrain_nodes`,
`ob1_nodes`, `node_links` (`duplicate_candidate` rows only — the
move/merge `link_type`s belong to Phase 4), `chunks`, `edges`,
`sync_state`. `plane_workitems` exists in the schema already but
isn't populated until Phase 2. Full detail: `docs/cro-index-schema.md`.

**Resolved 2026-11-04: `chunks`/`edges` are populated in this phase,
not Phase 2.** Phase 2 only *searches* what this phase populates —
it doesn't do any indexing itself. This means the local embedding
model (`ElBruno.LocalEmbeddings`, settled 2026-11-04) is needed as
part of this phase's own code, not deferred.

**Added step (2026-11-04):** before reading any Thought content,
sync `brains` and `thebrain_types` against TheBrain's live
`/brains` and `/thoughts/{brainId}/types` endpoints — both are
freeform, user-editable lists (confirmed live: 8 real Types just in
Growth), so this bootstrap run is also the first time these two
lookup tables get populated for real, not just a one-off aside. See
`docs/phase-roadmap.md`'s "Lookup-table resync" note — the same sync
has to happen again before Phase 3 and Phase 4 run too.

## 4. Acceptance tests

**0. The bootstrap data flow itself, proven first.** TheBrain feeds
`cro_index` and the new local OB1, one direction, TheBrain never
written to. Success: content that exists only in TheBrain has a
`thebrain_nodes` row, at least one `chunks` row with a real 384-dim
embedding, and (where applicable) `edges` rows, each correctly linked
back to its real TheBrain Thought ID — checked by querying `cro_index`
directly, not through a search feature (that's Phase 2; it doesn't
exist yet). Success also requires: the local OB1 Docker container is
running and reachable, and the thought count in local OB1 matches the
cloud source after transfer. Nothing else is validated until this
holds.

1. `cro_index` can be deleted and rebuilt from TheBrain + OB1 with zero
   data loss — proves the "disposable index" rule actually holds.
2. The known duplicate case (two "Kittery" Thoughts, Growth and Filing
   Cabinet) produces a `duplicate_candidate` row in `node_links` —
   proves the flagging behavior works on a real, confirmed example,
   not just a hypothetical.
3. Running the bootstrap a second time against unchanged source data
   produces no duplicate `cro_index` rows and no duplicate OB1
   thoughts — proves it's safe to use as "the base for a future
   resync," not a one-shot script that breaks on a second run.

*(Tests about search quality — multi-source results, serendipity,
sensitivity gating, live re-read at answer time — moved to Phase 2;
see `docs/phase-2-plan.md`. They were originally drafted here before
Phase 1/2 were split apart on 2026-11-04.)*

## 5. Explicit exclusions for Phase 1

- Searching/looking anything up — Phase 2.
- Acting on a reorg flag (actually moving a Thought/Note, or merging a
  duplicate) — Phase 4. This phase only flags.
- Any capture/ingest flow beyond the one-time bootstrap read — the
  "please remember [link]" command, email ingestion, the public
  ingest site — Phase 3 and Phase 5.
- Plane — not touched until Phase 2.
- The holistic dashboard.
- Standing resurfacing directives, proactive skill-pull — not placed
  in any phase yet, see `docs/phase-roadmap.md`'s known-gaps list.
- Write support to TheBrain of any kind. TheBrain is read-only this
  phase, full stop — no exception (the brain-reorg write capability
  discussed earlier moved to Phase 4, not kept here).
- Home Assistant integration.
- The public-ingest OIDC/account-allowlist auth layer.
- Repo-grounded retrieval as a CRO-side feature — cancelled entirely,
  not deferred (decided 2026-10-22). CRO never reads a repository
  directly; a skill reads its own repo and only calls CRO to search or
  capture.
