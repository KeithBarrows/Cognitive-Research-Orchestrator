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

`brains` has one row per real TheBrain brain (confirmed live: 8
brains, including "Growth," "Filing Cabinet," "Blue Skies Unlimited").
`thebrain_types` has one row per real Type in each brain (confirmed
live: 8 real Types in Growth alone). Both have accurate
`last_synced_at` timestamps after the sync.

## Not yet designed

Nothing structural — the endpoints and the resync concept are both
confirmed live. `staleness_threshold_days` values themselves are a
user judgment call made after this sync, not part of this Feature.
