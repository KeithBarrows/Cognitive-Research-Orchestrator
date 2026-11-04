# Epic — Reorg

*(Formerly "Phase 4." File name stays `phase-4-plan.md` for stable
history — see `docs/phase-roadmap.md` for the full Epic list.)*

**Status:** Broad-stroke only (named 2026-11-04, moved out of the
original monolithic "Phase 1" draft once it was split into the
separate phase/Epic docs). Not yet detailed. See
`docs/phase-roadmap.md`.

## 1. Scope

Acts on what Epic 1 (and later, Epic 3) only ever flagged. Epic 1
never moves or merges anything by itself — this phase is where that
actually happens, with the user confirming each case.

**This is write support to TheBrain itself** — the one place in the
whole roadmap TheBrain stops being read-only. Every other phase keeps
TheBrain read-only.

## Features

- **Duplicate-across-brains resolution:** CRO surfaces a
  `duplicate_candidate` row from `node_links` (see
  `docs/cro-index-schema.md`) for the user to confirm as the same real
  entity — e.g. the two separate, unlinked "Kittery" Thoughts (Growth
  and Filing Cabinet), confirmed live during Epic 1 planning. CRO
  never auto-merges.
- **Restructure suggestion:** CRO proposes "should this be moved to
  [brain]?" for a given Thought — e.g. a Growth-brain Thought that
  looks like it belongs in Filing Cabinet. Folded in 2026-11-04 from
  the old plan's "reviewable relationship suggestions" (`docs/README.md`
  §15, now superseded) — that old phase named this alongside detection
  (orphan/stale/hub); detection itself lives in Epic 1, this Feature is
  the resolution half.
- **The actual move mechanism**, once a move is confirmed: move a
  Thought (and its Note) from one TheBrain brain to another, keeping
  `cro_index` in sync (`thebrain_nodes.source_brain_id` updated to
  match).

## 2. Not yet designed

- The actual move mechanism against TheBrain's live API. TheBrain
  supports creating/deleting Thoughts and Notes; moving between brains
  likely means recreate-in-target plus delete-from-source — not yet
  verified that this round-trips without data loss, including
  attachments (confirmed live in Epic 1 planning: some Thoughts carry
  attachments, e.g. a Flipboard bookmark link, not just note text).
- The restructure-suggestion UX — how CRO decides "this looks like it
  belongs in Filing Cabinet" in the first place.
- How `node_links` rows get created as `duplicate_candidate` in the
  first place (title match? something smarter?) — same open question
  as Epic 1/2.

## 3. Exclusions

Everything excluded through Epic 3, still excluded, plus: external
HTTP ingest (Epic 5).
