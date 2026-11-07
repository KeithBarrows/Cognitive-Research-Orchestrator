# Feature 03 — Duplicate Detection

*(Part of Epic 1 — Bootstrap. See `../../phase-1-plan.md` for the full
Epic; see `../../phase-roadmap.md` for the Plane EPIC/FEATURE/USER STORY
tagging convention this file is meant to seed.)*

## Scope

Folded in 2026-11-04 from the old plan's "Recovery and graph hygiene"
phase (`../../README.md` §15, now superseded). That old phase bundled
*detecting* anomalies with *resolving* them; this Feature keeps only
detection — resolution is Epic 4 (Reorg).

Detects, during the raw read (Feature 02), two records that look like
the same real-world thing by title match — the confirmed-live case of
"Kittery" existing as two separate, unlinked TheBrain Thoughts
(Growth and Filing Cabinet). CRO never auto-merges, and no actual move
happens in this Epic — that's Epic 4. This is the direct/title-match
case only; the embedding-based neighborhood-expansion case is
Feature 05 (deferred).

## Schema touched

`node_links` — one row per detected pair, `link_type =
'duplicate_candidate'`, `detection_method = 'title_match'`,
`confirmed_by_user = false` until a human confirms it in Epic 4.

## Dependency

Runs during/after Feature 02, since it needs `thebrain_nodes` rows
from both brains already populated to compare.

## Acceptance test

Title-match flagging. Independently list every title that appears in
two or more indexed brains. The set of `duplicate_candidate` rows
(`detection_method = 'title_match'`) must equal that set. Every such
row has `confirmed_by_user = false`, and no Thought is merged or
changed. (The "Kittery" pair is one instance, not the test. A
candidate is only a flag; whether the pair is truly the same thing is
the user's call in Epic 4.)

## Not yet designed

How a general (non-title-match) `node_links` `'reference'` row gets
created — still open, out of scope for this Feature specifically.
