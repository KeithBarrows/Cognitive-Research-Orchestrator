# Epic — Skill Hooks and Controlled Writes

*(New 2026-11-04, built entirely from the old plan's "Skill hooks and
controlled project writes" phase — `docs/README.md` §15, now
superseded. File name `phase-6-plan.md`, continuing the existing
numbering — see `docs/phase-roadmap.md` for the full Epic list.)*

**Status:** Broad-stroke only. Not yet detailed with live
verification the way Epic 0/1 were.

## 1. Scope

How an individual AI skill actually talks to CRO for context, and how
anything that skill wants to persist gets handled — the
skill-integration contract. Distinct from every other Epic: Epics 1-5
are about what's inside CRO's own data stores; this one is about the
boundary between CRO and the skills that call it.

**Core rule, carried over unchanged:** CRO never auto-receives a
skill's write. A skill's own persistence decision is surfaced to the
user, who decides whether to capture anything — CRO does not silently
change canon on a skill's behalf.

## Features

- **Pre-skill context hooks:** run from declarative blocks a skill
  itself defines (the `cro_context` schema named as an open question
  in `docs/phase-roadmap.md`'s cross-cutting section) — a skill
  states what context it needs, CRO supplies it before the skill
  runs.
- **Post-skill persistence analysis:** a skill-side behavior, not a
  CRO one. The skill decides what's worth keeping from its own run;
  CRO's job is only to surface that decision to the user correctly
  routed (which store, which project) — never to receive or act on
  the write itself.
- **Approval paths for canon and destructive changes:** a named gap
  this Epic needs to design concretely — what "approval" actually
  looks like for a skill-proposed canon change, not just that one is
  required.
- **Bounded operational audit retention:** keep a record of what
  skills asked for and what got surfaced, bounded in size/time —
  not an unlimited log.

**Old exit criterion, still the right bar:** "A skill receives
relevant forgotten context and surfaces correctly routed persistence
options to the user, who decides whether to capture anything, without
silently changing canon."

## 2. Not yet designed

Essentially everything — this Epic has not had the live-verification
pass the others got:

- The actual `cro_context` declarative-block schema and validation
  rules (already an open question in `docs/phase-roadmap.md`).
- What "approval paths for canon and destructive changes" concretely
  means — a UI flow? a CRO API response shape a skill must handle?
- How this Epic's "pre-skill context hooks" relate to Epic 2's Lookup
  — is a hook just a Lookup call with a fixed shape, or something
  separate?
- Audit retention bounds (size, time, or both) — not specified at all
  yet.

## 3. Exclusions

Everything excluded through Epic 5, still excluded.
