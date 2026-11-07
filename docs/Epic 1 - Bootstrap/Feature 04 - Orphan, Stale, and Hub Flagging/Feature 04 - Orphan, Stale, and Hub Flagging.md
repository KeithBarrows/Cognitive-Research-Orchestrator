# Feature 04 — Orphan, Stale, and Hub Flagging

*(Part of Epic 1 — Bootstrap. See `../../phase-1-plan.md` for the full
Epic; see `../../phase-roadmap.md` for the Plane EPIC/FEATURE/USER STORY
tagging convention this file is meant to seed.)*

## Scope

Fully designed 2026-11-04, all three settled through live verification
against the real Growth brain (see `../../cro-index-schema.md`'s
`node_flags` table):

- **Orphan** — zero rows in `node_links` and `edges`, either side.
- **Stale** — a `thebrain_types.staleness_threshold_days` value is set
  for the node's Type, and the node is older than it. Blank threshold
  or no Type at all (most Thoughts currently have none) = never stale.
  This also prevents a first-run flood on a brain that's years old —
  nothing is stale until a Type is explicitly given a number.
- **Hub (simple)** — 30+ total links/edges on a non-Type node. Type
  Thoughts (`kind=2`, e.g. "Rolodex," "Timeline") are never flagged,
  any size — confirmed live that Rolodex alone has 100+ children.
  Confirmed live against two ordinary Thoughts ("Quiver Software
  Development," 24 links; "Technologist & ASPInsider," 15 links) that
  30 doesn't over-flag normal well-connected content.

CRO never auto-merges or auto-resolves anything found here — every
flag is reviewed by the user in Epic 4. This is the simple,
count/threshold-based version of hub detection; the smarter
embedding-based "catch-all" version is Feature 05 (deferred).

## Schema touched

`node_flags` — one row per flagged node, `flag_type = 'orphan'` \|
`'stale'` \| `'hub'`.

## Dependency

Runs after Feature 02 has populated `thebrain_nodes`/`ob1_nodes`/
`node_links`/`edges`, and after Feature 01 has given `thebrain_types`
real `staleness_threshold_days` values to check against (blank is a
valid value and still usable — just means nothing of that Type is ever
stale).

## Acceptance test

Hub flagging. No `hub` row exists for any Type Thought (`kind=2`), at
any size — proves the Type-exclusion rule holds regardless of child
count. A regular Thought with 30+ links (if one exists in real data)
does produce a `hub` row. (Gap 3, 2026-11-05: no ordinary Thought with
30+ links is confirmed. After Epic 0 Feature 05 (TheBrain file sync),
search all six indexed brains for one. If none exists, decide then
whether to build a synthetic fixture in a scratch brain. Until then
the positive case is unproven.)

## Not yet designed

Nothing structural — all three rules are settled. The specific
per-Type `staleness_threshold_days` values beyond the two examples
already set (Software = 180 days; Medical/Financial = blank) are an
ongoing user judgment call, not a one-time design task.
