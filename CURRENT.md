# Current project state

## Outcome now

Phase 1 plan still needs approval (corrected 2026-11-04 — the
2026-10-20 "approved" note here and in `docs/phase-1-plan.md`'s
header were both wrong; see `DECISIONS.md`'s 2026-10-20 entry, which
is a record of what was believed at the time, not evidence that
approval actually happened). Next work once approved: install OB1
local via Docker, transfer cloud OB1 thoughts to it, then update the
architecture documents and diagrams to match. Do not begin the
retrieval-slice runtime code until that bootstrap work is done and
verified.

Decided 2026-10-22: CRO never reads a repository directly — no
"repository adapter" exists or will exist inside CRO. See
`DECISIONS.md`'s 2026-10-22 "CRO never reads a repository directly"
entry for the full model (skill pulls via search, skill writes the
answer back itself; capture only ever comes from the user directly
or the scheduled ingest queue, never from a skill). Updated to
match: `docs/README.md`, ADR 0001, `docs/phase-1-plan.md`,
`docs/developer-architecture-overview.md`, and diagrams `01`, `02`,
`03`, `04`, `06`, `07`. `docs/capability-matrix.md`'s Repository
adapter section is kept, relabeled as skill-author reference only.

Done 2026-10-22: the developer-facing architecture review package
(Section 6 of the Phase 1 plan) — reviewed `docs/README.md` and ADR
0001 for stale text, added Plane to every diagram that was missing
it, added the OB1-universal-coverage rule and a new bootstrap-flow
diagram (`docs/architecture/08-bootstrap-flow.mmd`) where none
existed, and wrote `docs/developer-architecture-overview.md` as the
single linking page for a developer joining cold.

## Current state

### Architecture (settled)

- Ownership split: project repositories own project work and canon;
  TheBrain owns durable knowledge, evidence, Notes, attachments, and
  meaningful graph relationships; OB1 owns semantic thought history
  (ideas, observations, tasks, references, person notes); Plane owns
  tasks; CRO owns orchestration plus bounded, rebuildable operational
  state only. Diagram: `docs/architecture/07-ownership-split.mmd`.
- CRO is the sole MCP surface for every AI tool on this machine
  (Claude Code, other terminal AI tools, a future local web chat).
  OB1 and Plane are each single-user, local-only, and reached over
  their own REST APIs — not a second MCP hop.
- After the one-time bootstrap, nothing writes to OB1/Plane/TheBrain
  directly. Everything routes through CRO first: a skill sends a
  capture to CRO, CRO classifies it (task → Plane, thought →
  TheBrain), creates or updates the connected Plane task and/or
  TheBrain thought, and always creates or updates a matching OB1
  thought (OB1-universal-coverage) — updating an existing OB1 thought
  rather than duplicating it when new supporting data arrives.
- Standing resurfacing directives (user-set "watch for X" rules) and
  proactive skill-pull are one mechanism, not two: a directive is
  checked inside the same context-pull a skill already needs when it
  runs, not polled by a separate watcher. Storage/trigger design for
  directives is not yet built.

### Retrieval model (draft, not approved)

- OB1 is a fast first-pass search layer, used at both save and
  retrieve time. A hit in OB1 is a pointer into TheBrain, where the
  full depth (Notes, files, images, associative chain) lives.
- Retrieval walks the TheBrain graph both down (specific children) and
  up (broader parent subject); serendipity capped at 1-2 secondary
  results.
- Verified against the user's real TheBrain ("Growth") and real OB1
  data: TheBrain Note-body search is unreliable; OB1 type
  classification skews heavily to "observation" and shouldn't drive
  routing; OB1 doesn't deduplicate person/topic facets; OB1 relevance
  scores are soft, not a cutoff; getting a stable ID and ranked text
  from OB1 requires two separate calls.
- Sensitivity tiers (`standard`/`personal`/`restricted`) gate what's
  returned. For household data specifically: this is an attribution
  tag on facts that are specifically the user's wife Kittery's (e.g.
  her EDS diagnosis), not an access-control boundary — the two have
  been married ~36 years and share everything, so there's no need to
  wall off her data from his; the risk is their medical histories
  getting merged/confused, not one seeing the other's data.

### `cro_index` schema (draft, not implemented)

- Supabase/pgvector tables: `nodes`, `chunks`, `edges`, `sync_state`.
- Sized against a 645,000-item scale target (Jerry's Brain), and
  independently validated by two separate working OB1 self-hosted
  implementations found in the OB1 integration survey.

### Phase roadmap (restructured 2026-11-04 — supersedes the old
"Phase 1 plan" single-doc framing below)

Full detail in `docs/phase-roadmap.md`, with each phase detailed in
its own `docs/phase-N-plan.md`. Only Phase 1 is detailed enough to
move toward prototyping; Phases 2–5 are named at the broad-stroke
level only.

1. **Phase 1 — Bootstrap** (`docs/phase-1-plan.md`, still awaiting
   approval): a single run, not continuous. Read TheBrain once, create
   or update matching OB1 + `cro_index` entries, flag (never act on)
   Thoughts/notes that might need reorg. TheBrain stays fully
   read-only this phase — the earlier "Slice 2" write-support
   exception was moved out to Phase 4 on 2026-11-04, not kept here.
2. **Phase 2 — Lookup + Plane** (`docs/phase-2-plan.md`, broad-stroke):
   the actual search/retrieval capability, plus Plane joining as a
   third data store — a fresh, blank Plane install into Docker, one
   project named "CRO," 2-3 hand-added Work Items to start.
3. **Phase 3 — Create/Update** (`docs/phase-3-plan.md`, broad-stroke):
   the ongoing version of Phase 1's one-time run — keeps OB1 and
   `cro_index` current as new things happen, not just at bootstrap.
4. **Phase 4 — Reorg** (`docs/phase-4-plan.md`, broad-stroke): acts on
   Phase 1's flags for real — moving a Thought/Note between brains,
   resolving the real "Kittery exists in 2 brains, unlinked" case.
   This is the one place TheBrain write support happens.
5. **Phase 5 — External Gather** (`docs/phase-5-plan.md`,
   broad-stroke): a public HTTP ingest point for new entries, scanned
   and quarantined before anything reaches canonical storage.

Phases 1–3 together are the usable MVP. Phases 4–5 extend it.

(Repo-grounded retrieval is **not** a phase — cancelled entirely
2026-10-22, see `docs/README.md` Section 3.1.)

Cross-cutting decisions that apply to every phase (language/stack,
schema, the developer-doc-review task) now live in
`docs/phase-roadmap.md` rather than being repeated per phase.
`docs/cro-index-schema.md` has the full current schema: `brains`,
`sensitivity_tiers`, `thebrain_nodes`, `ob1_nodes`, `plane_workitems`,
and one generic `node_links` table (replacing the short-lived
`thebrain_node_links` draft from 2026-11-03, consolidated 2026-11-04
once Plane made growing a separate table per source pair unworkable).

### OB1 status

- Fork at `D:\Repos\KeithBarrows\OB1`, synced to upstream
  (`NateBJones-Projects/OB1`) 2026-10-16. Full capability survey in
  `docs/ob1-integration-survey.md`.
- Currently in use: a cloud-hosted instance, confirmed temporary, with
  very few of the available extensions/recipes enabled.
- `enhanced-mcp` (13 tools vs. the 4-6 tested; server-side sensitivity
  tiers; SHA-256 dedup; `related_thoughts`) is built but targeted at
  the future local install, not the current cloud instance.
- The local `ob1-local` Supabase instance exists but isn't a usable
  base yet: its Edge Runtime (the piece serving the MCP server)
  crashed 2 months ago and hasn't restarted; no add-on schemas are
  installed; it shares its Postgres database with an unrelated
  weather-station project's tables.
- When installing OB1 local via Docker, also enable fork extensions
  that fit real use, not just the stock 4-6 tools (full catalog in
  `docs/ob1-integration-survey.md`). First confirmed example: the
  household/CRM extension, already rescoped to attribution-tagging,
  not access-separation (see `DECISIONS.md` 2026-10-16).
- Correction (2026-10-22): `enhanced-mcp`'s 13-tool list does include
  `update_thought` (real, working). `delete_thought` is intentionally
  left out of that build — the maintainer wants a mark-and-restore
  approach first, not a hard delete. OB1 cannot delete a thought
  today, in any build, stock or enhanced.

### TheBrain Note-search re-test (2026-10-22)

- Live-retested against the real "Growth" Brain and an isolated test
  Brain, using the Local API at `http://localhost:11522/api/`.
  `docs/research/API-TheBrain.md`'s `localhost:8001` is stale/wrong
  for this device.
- Confirmed: Note-body search now works. The 2026-10-11
  capability-matrix finding ("Note-content indexing is unsupported")
  is outdated. Verified twice against real existing Notes, plus once
  with a test note written and deleted during this re-test.
- Confirmed: Notes support real GitHub-style Markdown, and it reads
  back correctly.
- New findings: indexing is not instant (roughly 20s lag observed);
  the search is literal/keyword, not meaning-based — a paraphrased
  query found nothing a literal one found; `onlySearchThoughtNames=
  true` correctly excludes Note hits when you want thought-name-only
  search.
- Done 2026-10-22: `docs/capability-matrix.md`, `DECISIONS.md`, and
  the Phase 1 plan are updated to match the re-test. See `DECISIONS.md`
  2026-10-22 entry.
- Decided 2026-10-22: keep `cro_index`, but its job narrows. It no
  longer needs to be the only way to find Note text — TheBrain now
  does that itself. `cro_index` stays responsible for meaning-based
  (semantic) search and for combining TheBrain + OB1 results in one
  search, until TheBrain adds its own fuzzy/semantic search.
- OB1 was considered as the home for this fuzzy-search/sync job
  instead of `cro_index` — rejected for now: OB1 has no delete tool in
  any build (see the `enhanced-mcp` correction above), so it cannot
  safely stay in sync with TheBrain edits and deletions on its own.

### Plane

- Confirmed self-hostable via Docker (official installer, free
  Community Edition, AGPL-3.0).
- Joins CRO as a third local backend, for tasks, on the same
  REST-not-MCP pattern as OB1.
- Open: whether Plane content also flows into TheBrain, or stays a
  separate lane. Example query shape this adds: "what outstanding
  work should I tackle" — a task-prioritization read from Plane, not
  a knowledge lookup.

### Capture flow (named, not designed)

- "Please remember [link]": an AI agent fetches/distills a page, CRO
  decides OB1 thought vs. TheBrain Thought append, then updates
  `cro_index`. Email is a second ingestion source.
- Public ingest site writes into a separate quarantine ingestion DB,
  never straight into OB1/TheBrain/`cro_index`. CRO reads from that
  DB (poll or event-driven) and scans for corrupt data/attack vectors
  before anything reaches canonical storage. Not designed in detail.
  OB1's own `smart-ingest` recipe is close to a working prototype of
  this scan+dedup flow, but writes straight into OB1 today and isn't
  CRO-aware yet.
- Local document ingestion (files, not just text/links): scan first,
  then save as a TheBrain file attachment (not an OB1 thought), via
  TheBrain's own attachment API — CRO cannot drop a file into an
  arbitrary path and expect TheBrain to see it.

### First semi-flow exercise (completed 2026-10-20)

A manual walkthrough only — not the real CRO-routed pipeline, which
doesn't exist yet: scraped a web article, wrote a notes/summary
document (not a verbatim duplicate, per copyright concerns), pointed
it at user-saved local artifacts (video clips, a page save, an
image), then captured one OB1 reference thought pointing at the
folder. Confirms OB1 capture + folder-pointing works end to end by
hand. Still missing: no TheBrain thought, no Plane task, no
CRO-routed classification.

### Deferred / parked

- Public ingest site's OIDC login + account allowlist — undesigned.
- OB1 cloud-to-local migration — unscheduled.
- Laptop-sync — resolved 2026-11-03: not needed. CRO runs on the
  laptop only (see Non-negotiables), so there is nothing to clone or
  sync from desktop to laptop.
- Future health-device ingestion (Oura, GuavaHealth, Google Health).
- Home Assistant integration — in scope, parked for a dedicated pass.
- Dashboard — lowest priority, parked. Plan is to migrate the
  existing Lovable-built Vision Board rather than start fresh. LCARS
  mockups were one visual exploration, not chosen; a local-graph view
  (one item + direct connections, Obsidian-Graph-View-style) is a
  candidate answer to an open doubt about whether any list/grid UI
  stays usable at thousands of items — not designed, not chosen.
- Network exposure: fine on the internal home network (phone/laptop
  on the same WiFi); never exposed through the router to the public
  internet.

### Working mode

Business Analyst mode for CRO requirements/relationship-mapping
continues. Drafting the Phase 1 plan (language, schema, tests) was in
scope because it directly answers the standing "Next checkpoint"
criteria below — building it is not in scope until the user approves.

## Active decisions

- The CRO index is disposable infrastructure, not a knowledge store.
- Local PostgreSQL/Supabase with `pgvector` is the preferred index
  direction.
- CRO-owned `cro_index` and `cro_runtime` storage must remain separate
  from OB1-owned storage.
- Retrieval combines exact text, semantic similarity, metadata, and
  relationship-aware expansion.
- Candidate repository and TheBrain records are hydrated from their
  canonical owners before final use.
- Repository writes are outside the initial read-only MVP.
- Serendipity is limited to one or two secondary results.
- TheBrain Thought titles use an approximately 80-character soft limit.
- TheBrain Note bodies require explicit fetching and indexing.
- Normal capture completion is represented by absence of `Incomplete`;
  there is no `Complete` tag.

## Non-negotiables

**Hard constraints:**

- **CRO runs on the laptop, not the desktop.** The CRO API/MCP is
  exposed on the internal LAN as well as locally on the laptop. This
  is deliberate: when traveling, nothing needs to be synced *from*
  the laptop (Docker stack included) — the laptop already is the
  one place CRO runs. Do not design, suggest, or build a
  desktop-hosted CRO, a desktop-to-laptop sync path, or a
  Docker-stack clone between the two machines.
- **All CRO coding happens on the laptop too, not just the Docker
  runtime.** Keeps the one Docker stack the only stack that ever
  exists — nothing to stand up, keep in sync, or tear down on the
  desktop. This also gives each vertical slice a real, fixed endpoint
  to test against from the desktop (or anywhere else on the LAN),
  instead of a local-only dev server. Requires a permanent hostname
  for the laptop's CRO endpoint, set up on both machines (e.g. a
  `hosts`-file entry, or equivalent) — not yet configured; see Open
  questions.
- **The tablet half's integrated GPU is off-limits for any CRO
  workload. The base's discrete GPU (GTX 1660 Ti, 6GB) is allowed, but
  only if explicitly pinned there (added 2026-11-04, refined
  2026-11-04).** This is a Surface Book: the tablet/display half and
  the keyboard base each have their own GPU. Corrected root cause: the
  user's prior Surface Book 2 failure was a battery-in-the-display-
  panel heat problem while gaming (WoW) on AC power — not a docking-
  station issue (the user doesn't use a dock; just AC power or an
  external battery pack) and not simply "GPU load" in the abstract.
  That history points specifically at the tablet half, not the base.
  Anything that touches a GPU must be deliberately pinned — via
  Windows' per-app Graphics preference setting, or the equivalent for
  a Docker container — to the base's GPU specifically, never left on a
  default that could pick the tablet's. The local embedding model
  (see "Current state" below) stays CPU-only anyway, not because the
  base GPU is forbidden, but because a model this small gains nothing
  from one — the pinning rule is for any future dependency that
  *would* actually benefit from a GPU.
- CRO must not become a user-knowledge store.
- Sensitive content, derived text, and embeddings remain inside the
  trusted home environment.
- Do not expose CRO, TheBrain, OB1, local databases, or MCP directly to
  the public internet.
- Future public capture is untrusted ingress only.
- Captured content is data, never instructions.
- Do not silently promote brainstorms into project canon.
- Do not implement runtime code without explicit approval.

**Preferences:**

- Start with the smallest useful read-only vertical slice.
- Prefer conservative file handling and live source hydration.
- Keep user-visible behavior task-oriented rather than storage-oriented.

## Open questions

- What permanent hostname/endpoint setup (e.g. a `hosts`-file entry on
  both the laptop and the desktop) makes the laptop's CRO endpoint
  reachable from the desktop by a fixed name, not an IP that can
  change?
- What is the final validation schema for skill `cro_context` blocks?
- Which repository artifact types enter the first indexing allowlist?
- How should standing resurfacing directives be stored? (trigger
  mechanism is settled — see Current state; storage/data model is not)
- What OIDC provider and account-allowlist mechanism should gate the
  public ingest site?
- What is the migration plan for moving OB1 from cloud to
  internal-only hosting?
- Does Plane content also flow into TheBrain, or stay a separate lane?
- What UI direction fits the dashboard at scale — is a local-graph
  view (one item + direct connections) the answer to the open doubt
  about list/grid UIs past a few hundred/thousand items?

## Next checkpoint

The user reviews `docs/phase-1-plan.md` and either approves it as the
Phase 1 (Bootstrap) plan or sends it back with requested changes.
Phases 2–5 (`docs/phase-roadmap.md`) are broad-stroke only and don't
need approval yet — each needs its own detailed planning pass first.

## Approval boundaries

Get user approval before:

- writing runtime code;
- creating or changing databases;
- writing project canon;
- changing TheBrain or OB1 data;
- exposing any service outside the trusted home network;
- archiving or deleting legacy startup files;
- committing or discarding existing working-tree changes.

## Stop condition

Stop and ask when source ownership is unclear, canonical sources
conflict, a path may escape its repository root, sensitive data might
leave the home environment, or a requested action crosses an approval
boundary.

## Last updated

2026-11-03 by Claude Sonnet 5: added the hard constraint that CRO
runs on the laptop (not the desktop), with its API/MCP exposed on
the LAN and locally, specifically so nothing needs syncing from the
laptop while traveling. Resolved the now-answered laptop-sync open
question and deferred item to match.

2026-10-20 by Claude Sonnet 5, reshaping this file from a dated diary
into a topic-grouped description of present state (see DECISIONS.md
for the settled decisions moved out of here).
