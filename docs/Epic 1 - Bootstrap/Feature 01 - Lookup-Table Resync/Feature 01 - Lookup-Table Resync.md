# Feature 01 — Lookup-Table Resync

*(Part of Epic 1 — Bootstrap. See `../../phase-1-plan.md` for the full
Epic; see `../../phase-roadmap.md` for the Plane EPIC/FEATURE/USER STORY
tagging convention this file is meant to seed.)*

## Scope

Before reading any Thought content, sync `brains` and `thebrain_types`
against TheBrain's live `/brains` and `/thoughts/{brainId}/types`
endpoints. Both lists are freeform and user-editable — confirmed live
(8 real Types exist in Growth right now) — so this is the first time
these two lookup tables get populated for real, not a one-off aside.
Standing step: the same sync has to happen again before Epic 3 and
Epic 4 run too, not just once here.

## Schema touched

`brains`, `thebrain_types` (including the `staleness_threshold_days`
column — populated/edited by the user after this sync runs, not set
automatically from TheBrain, since TheBrain has no such concept).

## Dependency

Runs first, before Feature 02 (Bootstrap Data Flow) reads any Thought
content — every `thebrain_nodes.category_type_id` FK needs a real
`thebrain_types` row to point at.

## Acceptance test

Every brain in TheBrain's live `/brains` list has a row in `brains`, and
every Type in each brain's live Types list has a row in
`thebrain_types`. Live rows have a `last_synced_at` from this run. Any
other rows are ones that vanished from TheBrain; each is kept and
flagged `deleted`. (On 2026-11-06 this was 8 brains and 8 Types in
Growth; the count can change and is not part of the test.)

## Not yet designed

Nothing structural — the endpoints and the resync concept are both
confirmed live. `staleness_threshold_days` values themselves are a
user judgment call made after this sync, not part of this Feature.
