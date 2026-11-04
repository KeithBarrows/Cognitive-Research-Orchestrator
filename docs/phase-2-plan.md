# Epic — Lookup + Plane

*(Formerly "Phase 2." File name stays `phase-2-plan.md` for stable
history — see `docs/phase-roadmap.md` for the full Epic list.)*

**Status:** Broad-stroke only (named 2026-11-04). Not yet detailed —
needs its own live-verification pass (same treatment Epic 1 got
against TheBrain/OB1) before it's buildable. See
`docs/phase-roadmap.md`.

## 1. Scope

**Lookup:** given a question, search `cro_index` (vector + full-text)
for candidates drawn from TheBrain, OB1, and (once introduced below)
Plane. Expand 1-2 hops via the cached graph `edges` table when useful,
then re-read the live canonical source before answering. Read-only
against all three sources.

**Plane joins as the third data store.** The actual Docker install
moved to `docs/phase-0-plan.md` (2026-11-04) — installs happen there,
not here. What's left for this phase:

- A **single Plane project named "CRO"** (fresh, blank — not the
  existing cloud Plane workspace already connected to this session,
  confirmed live to belong to the writing/CreativeOS projects instead:
  Author Operations, JT Kaelen, Infrastructure, Quantum Fracture
  Press — no CRO project there).
- The user hand-adds just 2-3 Work Items to start, rather than CRO
  populating it automatically.
- Schema: `plane_workitems`, settled in `docs/cro-index-schema.md`,
  confirmed against a real live work item's fields (title, body,
  status, tags, optional start/end dates). Unlike TheBrain/OB1
  (populated by Epic 1's bootstrap), Plane is introduced in this
  phase — so indexing the 2-3 hand-added Work Items into `chunks`/
  `plane_workitems` happens here too, not in Epic 1.

## Features

- **Lookup query:** given a question, search `cro_index` (vector +
  full-text) for candidates, re-read the live canonical source before
  answering. The core of this Epic; see Scope above.
- **Provenance and serendipity hop:** every result traces back to a
  real source record; a narrow query may surface 1-2 broader related
  items via one hop up the TheBrain graph. Folded in 2026-11-04 from
  the old plan's "Read-only context recall" phase (`docs/README.md`
  §15, now superseded), which described this as "assemble context
  packets... preserve provenance... cap serendipity at two" — same
  rule, now named as its own Feature rather than buried in a phase
  description.
- **Plane onboarding:** seed and index the "CRO" project's 2-3
  hand-added Work Items. See Scope above.
- **Standing resurfacing directives — folded in 2026-11-04.** Moved
  here from `docs/phase-roadmap.md`'s "known gaps" list, where it sat
  unplaced; the old plan's "Relevance and resurfacing" phase
  (`docs/README.md` §15, now superseded) had real designed content
  for it:
  - Compute source volatility and temporal relevance.
  - Add stale and supersession review (flag when something's likely
    outdated, not just old).
  - Record durable behavior feedback in OB1 (what the user actually
    found useful).
  - Bounded forgotten-item retrieval — resurface useful older
    material without repetitive noise.
  - **Placement is a judgment call, not a certainty:** this is
    proactive surfacing, not reactive search, so it's arguably its
    own Epic rather than a Feature of Lookup. Placed here because it
    shares Lookup's retrieval machinery (`cro_index`, `edges`,
    serendipity) rather than needing its own data flow — revisit if
    it turns out to need more than that.

## 2. Acceptance tests (moved here from the original Epic 1 draft,
2026-11-04 — these are about search quality, which is this phase's
job, not Epic 1's bootstrap)

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

Resolved since this doc was first written (2026-11-04): embedding
model/dimension, chunk-splitting rule, `edges`/`sync_state` detail —
all settled now in `docs/cro-index-schema.md`. What's actually still
open for this phase specifically:

- How `node_links` rows get created in general (beyond the Epic 1
  duplicate-flagging case) — manual, title-similarity match, graph-edge
  inference.
- Attribution (whose fact something is) as a concept separate from
  sensitivity (how private it is) — not modeled anywhere yet.
- The actual Lookup query logic itself (how a question becomes a
  vector search plus a graph-hop expansion) — named in Scope above,
  not yet designed step-by-step.

## 4. Exclusions

Everything Epic 1 excluded, still excluded here, plus: acting on a
reorg flag (Epic 4), ongoing capture beyond manual lookup (Epic 3),
external HTTP ingest (Epic 5).
