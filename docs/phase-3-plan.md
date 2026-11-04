# Phase 3 Plan — Create/Update

**Status:** Broad-stroke only (named 2026-11-04). Not yet detailed.
See `docs/phase-roadmap.md`.

## 1. Scope

The ongoing version of what Phase 1 did once. Phase 1 is a single run
that sits in reserve; Phase 3 is what keeps OB1 and `cro_index` current
going forward, as new things happen — not a repeat of the bootstrap,
a continuous capture path.

This is likely where `CURRENT.md`'s existing "Capture flow (named, not
designed)" section and the "OB1-universal-coverage" rule (every
capture creates or updates a matching OB1 thought, never a straight
pass-through to just one system) actually get built — both already
exist as named ideas, just never assigned to a phase before now.

## 2. Not yet designed

Essentially everything below the one-line scope above:

- What actually triggers a create/update (a skill calling CRO
  directly? a scheduled re-scan of TheBrain/OB1/Plane for changes
  since Phase 1's bootstrap?).
- How a capture gets classified (task → Plane, thought → TheBrain,
  always → OB1) — named in `CURRENT.md` as a rule, never implemented.
- Whether this phase also produces new reorg-candidate flags (same
  mechanism as Phase 1's `duplicate_candidate` rows), or that stays a
  Phase-1-only, one-time thing.
- Relationship to Phase 2's Lookup — does a lookup ever trigger an
  update (e.g. re-syncing a stale node on read), or are the two fully
  separate?

## 3. Exclusions

Everything excluded through Phase 2, still excluded, plus: acting on
a reorg flag (Phase 4), external HTTP ingest (Phase 5).
