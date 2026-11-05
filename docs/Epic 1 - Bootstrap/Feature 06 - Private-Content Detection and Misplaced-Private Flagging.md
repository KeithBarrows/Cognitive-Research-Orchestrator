# Feature 06 — Private-Content Detection and Misplaced-Private Flagging

*(Part of Epic 1 — Bootstrap. See `../phase-1-plan.md` for the full
Epic; see `../phase-roadmap.md` for the Plane EPIC/FEATURE/USER STORY
tagging convention this file is meant to seed.)*

## Scope

New 2026-11-05. TheBrain's own `acType` field is a real, undocumented
"Private" marker — confirmed live on "Val Docs" and its 5 children (Tax
Returns, Collections, Health Records, Parenting Plan, Utility Payments
& Agreements), all `acType=1`. It's unreliable on its own — confirmed
live: under "Health Records," "Surgeries" is marked Private while
clearly-medical siblings "EDS" and "Research Info" are not.

Two parts:

1. **Capture it raw** as `thebrain_nodes.access_type` during Feature
   02's raw read. It becomes an **input signal** to
   `sensitivity_tier_id` classification, never a blind copy — CRO's
   own judgment still has to catch what the user's manual marking
   missed (the "EDS" case).
2. **Flag misplaced Private content** (`node_flags`, `flag_type =
   'misplaced_private'`) — a Private TheBrain node (`access_type=1`)
   whose `source_brain_id` isn't the one `brains` row with
   `is_private_home = true` (Filing Cabinet). Flag only, same as every
   other Epic 1 flag — Epic 4 decides what, if anything, moves.

## Schema touched

`thebrain_nodes.access_type` (new), `thebrain_nodes.sensitivity_tier_id`
(classification now considers `access_type`), `brains.is_private_home`
(new, user-set), `node_flags` (`misplaced_private` rows).

## Dependency

Needs Feature 01 to have `brains.is_private_home` set (a user judgment
call, same pattern as `thebrain_types.staleness_threshold_days` — not
auto-derived from TheBrain). Needs Feature 02's raw read to have
populated `thebrain_nodes.access_type` for every node before this can
flag anything.

## Acceptance test

The known case ("Val Docs" and its 5 children, all `access_type=1`,
all in Growth) produces 6 `misplaced_private` rows; a Private node
already in Filing Cabinet does not.

## Not yet designed

Nothing structural. The exact weight `access_type=1` carries in
`sensitivity_tier_id` classification (vs. CRO's own content-based
judgment) is an implementation-time calibration, not an open design
question — the rule (input signal, not blind copy) is already settled.
