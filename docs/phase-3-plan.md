# Epic — Create/Update

*(Formerly "Phase 3." File name stays `phase-3-plan.md` for stable
history — see `docs/phase-roadmap.md` for the full Epic list.)*

**Status:** Broad-stroke only (named 2026-11-04). Not yet detailed.
See `docs/phase-roadmap.md`.

## 1. Scope

The ongoing version of what Epic 1 did once. Epic 1 is a single run
that sits in reserve; Epic 3 is what keeps OB1 and `cro_index` current
going forward, as new things happen — not a repeat of the bootstrap,
a continuous capture path.

This is likely where `CURRENT.md`'s existing "Capture flow (named, not
designed)" section and the "OB1-universal-coverage" rule (every
capture creates or updates a matching OB1 thought, never a straight
pass-through to just one system) actually get built — both already
exist as named ideas, just never assigned to a phase before now.

## Features

Folded in 2026-11-04 from the old plan's "General capture" phase
(`docs/README.md` §15, now superseded) — that phase's whole content
maps to this Epic, almost entirely undesigned until now:

- **Heterogeneous capture input:** accept a URL, a file, or a loose
  idea as the thing being captured — not one fixed shape.
- **Reuse-or-create source Thoughts:** a capture either attaches to
  an existing TheBrain Thought or creates a new one — never a blind
  duplicate.
- **Preserve attachments and Notes:** whatever TheBrain's own model
  of the capture holds (file attachments, Note text) survives the
  capture path intact.
- **Capture loose ideas in OB1:** something with no clear TheBrain
  home yet still gets recorded, matching the `OB1-universal-coverage`
  rule already named in `CURRENT.md`.
- **Report project impact without changing canon:** a capture can say
  "this affects project X" without that being treated as an approved
  change to project X's actual canon — a reporting signal, not a
  write.
- **Classification:** task → Plane, thought → TheBrain, always → OB1
  — named in `CURRENT.md` as a rule, never implemented.
- **Old phase's exit criterion, still the right bar:** "A URL, a
  file, and a loose idea can each be preserved in the correct owner."

## 2. Not yet designed

- What actually triggers a create/update (a skill calling CRO
  directly? a scheduled re-scan of TheBrain/OB1/Plane for changes
  since Epic 1's bootstrap?).
- Whether this phase also produces new reorg-candidate flags (same
  mechanism as Epic 1's `duplicate_candidate` rows), or that stays a
  Epic-1-only, one-time thing.
- Relationship to Epic 2's Lookup — does a lookup ever trigger an
  update (e.g. re-syncing a stale node on read), or are the two fully
  separate?

## 3. Exclusions

Everything excluded through Epic 2, still excluded, plus: acting on
a reorg flag (Epic 4), external HTTP ingest (Epic 5).
