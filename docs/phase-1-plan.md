# Epic — Bootstrap

*(Formerly "Phase 1." Renamed 2026-11-04 — these are organized as
Epics now, each breaking down into Features and, eventually, User
Stories/PBIs. File name stays `phase-1-plan.md` for stable history;
see `docs/phase-roadmap.md` for the full Epic list and the Plane
tagging convention.)*

**Status:** Approved 2026-11-05. See `docs/phase-roadmap.md` for how
this fits with the other Epics. Next: Epic 0's installs
(`docs/phase-0-plan.md`), then this Epic's code.

## 1. Scope

**A single run, not a continuous process.** Read TheBrain once, raw.
For what's read: create or update matching entries in OB1 and in
`cro_index`. Flag — never act on — Thoughts/notes that might need
moving or reorganizing (the actual move is Epic 4). Once done, this
run's result sits in reserve as the base for a future resync, rather
than running again on its own.

Concretely:

- TheBrain is read once and feeds both `cro_index` and a new local OB1
  instance — one direction only, TheBrain is never written back to in
  this phase.
- The existing cloud OB1's thoughts are read once and transferred into
  the new local OB1 (OB1-to-OB1, no TheBrain involved).
- Flagging: CRO records a `node_links` row with `link_type =
  'duplicate_candidate'` (see `docs/cro-index-schema.md`) wherever it
  finds two records that look like the same real-world thing — e.g.
  the confirmed-live case of "Kittery" existing as two separate,
  unlinked TheBrain Thoughts (Growth and Filing Cabinet). This is a
  flag only. CRO never auto-merges, and no actual move happens in this
  phase — that's Epic 4.
- Searching/looking things up is explicitly **not** part of this
  phase — that's Epic 2.

## Features

- **Bootstrap data flow:** TheBrain → `cro_index` + new local OB1,
  one direction, raw read. See "Dependency" below.
- **Lookup-table resync:** sync `brains`/`thebrain_types` against
  TheBrain's live state before reading any Thought content. See
  "Schema touched this phase" below.
- **Reorg-candidate flagging — duplicate detection:** folded in
  2026-11-04 from the old plan's "Recovery and graph hygiene" phase
  (`docs/README.md` §15, now superseded). That old phase bundled
  *detecting* anomalies with *resolving* them; this Epic keeps only
  detection — resolution is Epic 4 (Reorg). Detects, as a `node_links`
  row with `link_type = 'duplicate_candidate'`, `detection_method =
  'title_match'`: two records that look like the same real-world
  thing (the confirmed-live "Kittery in 2 brains" case). CRO never
  auto-merges or auto-resolves anything found here — every flag is
  reviewed by the user in Epic 4.
- **Orphan/stale/hub flagging** — fully designed 2026-11-04, all three
  settled through live verification against the real Growth brain
  (see `docs/cro-index-schema.md`'s `node_flags` table):
  - **Orphan** — zero rows in `node_links` and `edges`, either side.
  - **Stale** — a `thebrain_types.staleness_threshold_days` value is
    set for the node's Type, and the node is older than it. Blank
    threshold or no Type at all (most Thoughts currently have none) =
    never stale. Prevents a first-run flood on a brain that's years
    old.
  - **Hub (simple)** — 30+ total links/edges on a non-Type node. Type
    Thoughts (`kind=2`, e.g. "Rolodex," "Timeline") are never flagged,
    any size — confirmed live that Rolodex alone has 100+ children.
    Confirmed live against two ordinary Thoughts ("Quiver Software
    Development," 24 links; "Technologist & ASPInsider," 15 links)
    that 30 doesn't over-flag normal well-connected content.
  - CRO never auto-merges or auto-resolves anything found here —
    every flag is reviewed by the user in Epic 4.
- **Post-bootstrap vector pass** — deferred second feature, 2026-11-04.
  Runs after the raw read above has populated `chunks`/`edges` for
  everything, not during it — both parts need real embeddings to tune
  a similarity cutoff against, which don't exist until the first
  bootstrap has run once:
  1. **Catch-all hub detection** (`node_flags`, `flag_type =
     'catchall_hub'`) — walks a node's neighbors up to 3 jumps out and
     compares their embeddings; flags it if the neighbors share no
     real theme. Catches what the simple link-count hub rule can't: a
     Thought with few links to genuinely unrelated things.
  2. **Duplicate-neighborhood expansion** (`node_links`, same
     `'duplicate_candidate'` link type, `detection_method =
     'embedding_similarity'`) — once a direct duplicate pair exists
     (the "Kittery" case), compares *their* neighbors pairwise by
     embedding too. A sub-thought hanging off "Kittery" in Growth
     might have a near-twin off "Kittery" in Filing Cabinet; this is
     the only way to find that one.
  - Re-run as needed, not a one-shot — unlike the rest of Epic 1, this
    is meant to be rerun against the populated `cro_index` whenever
    useful, not just once at bootstrap time.
- **Private-content detection — new 2026-11-05.** TheBrain's own
  `acType` field (raw-stored as `thebrain_nodes.access_type`) is a
  real, undocumented "Private" marker — confirmed live on "Val Docs"
  and its 5 children, all `access_type=1`. It's unreliable on its own
  (confirmed live: "Surgeries" is marked Private next to unmarked,
  clearly-medical siblings "EDS"/"Research Info"), so it's an **input
  signal** to `sensitivity_tier_id` classification, never a blind
  copy — corrects the schema's earlier "TheBrain has none" claim.
- **Misplaced-private flagging** (`node_flags`, `flag_type =
  'misplaced_private'`) — a Private TheBrain node outside the one
  brain marked `brains.is_private_home` (Filing Cabinet). Flag only,
  same as every other Epic 1 flag — Epic 4 decides what, if anything,
  moves. Confirmed live: "Val Docs" and its children are all Private
  and all in Growth, not Filing Cabinet.
- **Note-embedded cross-brain link detection — new 2026-11-05.**
  Confirmed live that TheBrain's real cross-brain `'native'` link
  (named but unconfirmed in the original `node_links` design) exists
  as a `brain://` URI inside a Note's Markdown body — found on "Health
  Records," resolving to "Health History" in Filing Cabinet. **This
  does not appear in the `/graph` response at all** (that Thought's
  `jumps` array was empty), so it cannot be found by the `edges` walk
  Feature 02 already does — it needs its own pass: scan every Note
  body for `brain://` URIs, decode their base64url-encoded brain/
  Thought GUIDs, and record a `node_links` row (`link_type =
  'native'`, `detection_method = 'note_brain_link'`).

## 2. Dependency: the bootstrap data flow

Diagrammed in `docs/architecture/08-bootstrap-flow.mmd`. This flow
*is* Epic 1 — there's no separate "feature" layered on top of it.

Bootstrap sub-steps, made explicit on approval (2026-10-20):

- Install OB1 local via Docker. The existing `ob1-local` Supabase
  instance is not reusable as-is (crashed Edge Runtime, shared
  Postgres with the weather-station project — see `CURRENT.md`'s OB1
  status note); this is a fresh install, not a repair.
- Transfer cloud OB1's thoughts into the new local OB1 by reading each
  thought from the cloud instance and writing it to the local instance
  (get-thoughts / save-thoughts calls). Exact tool names to confirm
  against the local instance's enhanced-mcp surface at implementation
  time — the cloud instance exposes list_thoughts/search_thoughts/
  capture_thought; the local one may differ.
- Update the architecture documents and diagrams (`docs/README.md`,
  `docs/architecture/*.mmd`) once the Docker install and transfer
  mechanism are implemented, so the diagrams match what actually runs
  rather than the planned version.

## 3. Schema touched this phase

`brains` (including the new `is_private_home` column), `thebrain_types`
(including the `staleness_threshold_days` column), `sensitivity_tiers`,
`thebrain_nodes` (including the new `access_type` column), `ob1_nodes`,
`node_links` (`duplicate_candidate` and `native` rows only — the
move/merge `link_type`s belong to Epic 4), `node_flags`
(`orphan`/`stale`/`hub`/`misplaced_private` from the raw-read pass;
`catchall_hub` from the deferred post-bootstrap vector pass), `chunks`,
`edges`, `sync_state`. `plane_workitems` exists in the schema already
but isn't populated until Epic 2. Full detail:
`docs/cro-index-schema.md`.

**Resolved 2026-11-04: `chunks`/`edges` are populated in this phase,
not Epic 2.** Epic 2 only *searches* what this phase populates —
it doesn't do any indexing itself. This means the local embedding
model (`ElBruno.LocalEmbeddings`, settled 2026-11-04) is needed as
part of this phase's own code, not deferred.

**Added step (2026-11-04):** before reading any Thought content,
sync `brains` and `thebrain_types` against TheBrain's live
`/brains` and `/thoughts/{brainId}/types` endpoints — both are
freeform, user-editable lists (confirmed live: 8 real Types just in
Growth), so this bootstrap run is also the first time these two
lookup tables get populated for real, not just a one-off aside. See
`docs/phase-roadmap.md`'s "Lookup-table resync" note — the same sync
has to happen again before Epic 3 and Epic 4 run too.

## 4. Acceptance tests

**0. The bootstrap data flow itself, proven first.** TheBrain feeds
`cro_index` and the new local OB1, one direction, TheBrain never
written to. Success: content that exists only in TheBrain has a
`thebrain_nodes` row, at least one `chunks` row with a real 384-dim
embedding, and (where applicable) `edges` rows, each correctly linked
back to its real TheBrain Thought ID — checked by querying `cro_index`
directly, not through a search feature (that's Epic 2; it doesn't
exist yet). Success also requires: the local OB1 Docker container is
running and reachable, and the thought count in local OB1 matches the
cloud source after transfer. Nothing else is validated until this
holds.

1. `cro_index` can be deleted and rebuilt from TheBrain + OB1 with zero
   data loss — proves the "disposable index" rule actually holds.
2. The known duplicate case (two "Kittery" Thoughts, Growth and Filing
   Cabinet) produces a `duplicate_candidate` row in `node_links` —
   proves the flagging behavior works on a real, confirmed example,
   not just a hypothetical.
3. Running the bootstrap a second time against unchanged source data
   produces no duplicate `cro_index` rows and no duplicate OB1
   thoughts — proves it's safe to use as "the base for a future
   resync," not a one-shot script that breaks on a second run.
4. The known hub case ("Rolodex," a Type Thought with 100+ children)
   produces **no** `node_flags` row — proves the Type-exclusion rule
   actually holds, not just the count rule. A regular Thought with 30+
   links (if one exists in real data) does produce a `hub` row.
5. The post-bootstrap vector pass (catch-all hub + duplicate-
   neighborhood expansion) can be run against the already-populated
   `cro_index` from test 0-3 and completes without needing a fresh
   TheBrain/OB1 read — proves it's genuinely a second, independent
   pass over the index, not hidden bootstrap-time work.
6. The known private-but-misplaced case ("Val Docs" and its 5
   children, all `access_type=1`, all in Growth) produces 6
   `misplaced_private` `node_flags` rows; a Private node already in
   Filing Cabinet does not.
7. The known Note-embedded cross-brain link ("Health Records" →
   "Health History" in Filing Cabinet, via a `brain://` URI in the
   Note body) produces a `node_links` row (`link_type = 'native'`,
   `detection_method = 'note_brain_link'`) pointing at the correct
   Filing Cabinet Thought — proves this is actually caught by a
   Note-body scan, not just assumed to be covered by the `edges` walk
   (which this same Thought's empty `/graph` `jumps` array disproves).

*(Tests about search quality — multi-source results, serendipity,
sensitivity gating, live re-read at answer time — moved to Epic 2;
see `docs/phase-2-plan.md`. They were originally drafted here before
Epic 1/2 were split apart on 2026-11-04.)*

## 5. Explicit exclusions for Epic 1

- Searching/looking anything up — Epic 2.
- Acting on a reorg flag (actually moving a Thought/Note, or merging a
  duplicate) — Epic 4. This phase only flags.
- Any capture/ingest flow beyond the one-time bootstrap read — the
  "please remember [link]" command, email ingestion, the public
  ingest site — Epic 3 and Epic 5.
- Plane — not touched until Epic 2.
- The holistic dashboard.
- Standing resurfacing directives, proactive skill-pull — not placed
  in any phase yet, see `docs/phase-roadmap.md`'s known-gaps list.
- Write support to TheBrain of any kind. TheBrain is read-only this
  phase, full stop — no exception (the brain-reorg write capability
  discussed earlier moved to Epic 4, not kept here).
- Home Assistant integration.
- The public-ingest OIDC/account-allowlist auth layer.
- Repo-grounded retrieval as a CRO-side feature — cancelled entirely,
  not deferred (decided 2026-10-22). CRO never reads a repository
  directly; a skill reads its own repo and only calls CRO to search or
  capture.
