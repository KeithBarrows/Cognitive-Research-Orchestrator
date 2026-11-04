# Phase 2 Plan — Lookup + Plane

**Status:** Broad-stroke only (named 2026-11-04). Not yet detailed —
needs its own live-verification pass (same treatment Phase 1 got
against TheBrain/OB1) before it's buildable. See
`docs/phase-roadmap.md`.

## 1. Scope

**Lookup:** given a question, search `cro_index` (vector + full-text)
for candidates drawn from TheBrain, OB1, and (once introduced below)
Plane. Expand 1-2 hops via the cached graph `edges` table when useful,
then re-read the live canonical source before answering. Read-only
against all three sources.

**Plane joins as the third data store, introduced in this phase.**
Confirmed with the user (2026-11-04):

- A **fresh, blank Plane install into Docker** — not reusing the
  existing cloud Plane workspace already connected to this session
  (that one belongs to the writing/CreativeOS projects, confirmed by
  listing it live: Author Operations, JT Kaelen, Infrastructure,
  Quantum Fracture Press — no CRO project there).
- **A single Plane project named "CRO."**
- The user hand-adds just 2-3 Work Items to start, rather than CRO
  populating it automatically.
- Schema: `plane_workitems`, already drafted in
  `docs/cro-index-schema.md` ahead of this phase, confirmed against a
  real live work item's fields (title, body, status, tags, optional
  start/end dates).

## 2. Acceptance tests (moved here from the original Phase 1 draft,
2026-11-04 — these are about search quality, which is this phase's
job, not Phase 1's bootstrap)

1. A question returns results drawn from TheBrain, OB1, and Plane —
   not just one source.
2. A result whose content only lives inside a TheBrain Note body is
   still found — confirms TheBrain's own Note search now finds literal
   text (reconfirmed 2026-10-22; TheBrain closed this gap itself).
   `cro_index` is still responsible for the meaning-based (semantic)
   matches TheBrain's literal search misses, and for combining results
   from all three sources in one search.
3. Every returned result is re-read from the live TheBrain/OB1/Plane
   source at answer time — never served from the cached index alone.
4. A narrow query can surface 1-2 broader related items via one hop up
   the TheBrain graph, capped at 2 (existing serendipity rule).
5. Anything tagged `sensitivity_tier = restricted` is never returned
   without explicit override — the Kittery-privacy mechanism is a hard
   requirement of this slice, not a someday feature. (Confirmed
   2026-11-04: `restricted` means actual medical/financial-grade
   content, e.g. Filing Cabinet's diagnosis records — not just a
   person's name appearing.)
6. A query with nothing good to find returns "nothing found," never a
   fabricated or low-confidence guess.

## 3. Not yet designed

- How `node_links` rows get created in general (beyond the Phase 1
  duplicate-flagging case) — manual, title-similarity match, graph-edge
  inference.
- Embedding model/API, dimension, and where embedding happens.
- Chunk boundaries and whether `sensitivity_tier_id` lives on the
  chunk, the node, or both (see `docs/cro-index-schema.md`'s "Who Am
  I" example).
- `edges` table detail, `sync_state` detail.
- Attribution (whose fact something is) as a concept separate from
  sensitivity (how private it is) — not modeled anywhere yet.

## 4. Exclusions

Everything Phase 1 excluded, still excluded here, plus: acting on a
reorg flag (Phase 4), ongoing capture beyond manual lookup (Phase 3),
external HTTP ingest (Phase 5).
