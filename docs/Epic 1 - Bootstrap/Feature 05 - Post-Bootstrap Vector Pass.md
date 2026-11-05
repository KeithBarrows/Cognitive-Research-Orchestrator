# Feature 05 — Post-Bootstrap Vector Pass

*(Part of Epic 1 — Bootstrap. See `../phase-1-plan.md` for the full
Epic; see `../phase-roadmap.md` for the Plane EPIC/FEATURE/USER STORY
tagging convention this file is meant to seed.)*

## Scope

Deferred, 2026-11-04 — unlike every other Feature in this Epic, this
one is meant to be **re-run** against the already-populated
`cro_index`, not run once during the raw read. Both parts need real
embeddings to tune a similarity cutoff against, which don't exist
until Feature 02 has run at least once:

1. **Catch-all hub detection** (`node_flags`, `flag_type =
   'catchall_hub'`) — walks a node's neighbors up to 3 jumps out (via
   `edges`/`node_links`) and compares their `chunks.embedding` values.
   If the neighbors share no real semantic theme, the node is a
   "catch-all" rather than a coherent hub — confirmed live that
   "Rolodex"'s 100+ children are all people (would pass a coherence
   check even though it fails the flat link-count one); a true
   catch-all would fail both. Catches what Feature 04's simple
   link-count rule can't: a Thought with few links to genuinely
   unrelated things.
2. **Duplicate-neighborhood expansion** (`node_links`, same
   `'duplicate_candidate'` link type as Feature 03, `detection_method
   = 'embedding_similarity'`, `similarity_score` set) — once a direct
   duplicate pair exists (Feature 03's "Kittery" case), compares
   *their* neighbors pairwise by embedding too. A sub-thought hanging
   off "Kittery" in Growth might have a near-twin off "Kittery" in
   Filing Cabinet; this is the only way to find that one.

Neither part's similarity cutoff can be picked by reasoning alone — it
needs tuning against real embeddings from a real `cro_index`.

## Schema touched

`node_flags` (`catchall_hub` rows), `node_links` (`duplicate_candidate`
rows with `detection_method = 'embedding_similarity'` and a real
`similarity_score`).

## Dependency

Needs Feature 02 to have populated `chunks`/`edges` for (ideally) the
whole brain at least once. Re-run on demand after that — not gated on
every other Feature in this Epic completing first, since it's a
separate pass over already-indexed content, not part of the raw read
itself.

## Acceptance test

The post-bootstrap vector pass can be run against the already-
populated `cro_index` from Features 01-04 and completes without
needing a fresh TheBrain/OB1 read — proves it's genuinely a second,
independent pass over the index, not hidden bootstrap-time work.

## Not yet designed

The actual similarity cutoff for "no real theme" (catch-all hub) and
for "similar enough to be a near-duplicate" (neighborhood expansion).
Both are explicitly left open until there's real embedding data from a
completed Feature 02 run to tune against — this is the one open design
question left in Epic 1, and it's deferred on purpose, not an
oversight.
