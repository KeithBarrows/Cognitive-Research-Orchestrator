# Phase 4 Plan — Reorg

**Status:** Broad-stroke only (named 2026-11-04, moved out of the
original Phase 1 draft once Phase 1/2/3/4/5 were split apart). Not yet
detailed. See `docs/phase-roadmap.md`.

## 1. Scope

Acts on what Phase 1 (and later, Phase 3) only ever flagged. Phase 1
never moves or merges anything by itself — this phase is where that
actually happens, with the user confirming each case.

- **Restructure suggestion:** CRO proposes "should this be moved to
  [brain]?" for a given Thought — e.g. a Growth-brain Thought that
  looks like it belongs in Filing Cabinet.
- **Duplicate-across-brains resolution:** CRO surfaces a
  `duplicate_candidate` row from `node_links` (see
  `docs/cro-index-schema.md`) for the user to confirm as the same real
  entity — e.g. the two separate, unlinked "Kittery" Thoughts (Growth
  and Filing Cabinet), confirmed live during Phase 1 planning. CRO
  never auto-merges.
- **The actual move mechanism**, once a move is confirmed: move a
  Thought (and its Note) from one TheBrain brain to another, keeping
  `cro_index` in sync (`thebrain_nodes.source_brain_id` updated to
  match).

**This is write support to TheBrain itself** — the one place in the
whole roadmap TheBrain stops being read-only. Every other phase keeps
TheBrain read-only.

## 2. Not yet designed

- The actual move mechanism against TheBrain's live API. TheBrain
  supports creating/deleting Thoughts and Notes; moving between brains
  likely means recreate-in-target plus delete-from-source — not yet
  verified that this round-trips without data loss, including
  attachments (confirmed live in Phase 1 planning: some Thoughts carry
  attachments, e.g. a Flipboard bookmark link, not just note text).
- The restructure-suggestion UX — how CRO decides "this looks like it
  belongs in Filing Cabinet" in the first place.
- How `node_links` rows get created as `duplicate_candidate` in the
  first place (title match? something smarter?) — same open question
  as Phase 1/2.

## 3. Exclusions

Everything excluded through Phase 3, still excluded, plus: external
HTTP ingest (Phase 5).
