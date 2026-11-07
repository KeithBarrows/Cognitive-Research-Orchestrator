# Current project state

## Outcome now

**Where we are (2026-11-06).** Epic 0 (Installs, no CRO code;
`docs/phase-0-plan.md`) is in progress, one Feature at a time. Epic 1
(Bootstrap, `docs/phase-1-plan.md`, 8 Feature files) is approved and
waits for Epic 0.

**Done and verified:** Feature 01 Docker Desktop; 02 dedicated
Postgres + pgvector (`cro_index`, 11 tables via Flyway migrations
V001-V004, `vector(768)`); 03 OB1 local (Supabase stack + Ollama, our
own `update` and `delete` functions); 04 Plane (v1.4.3, workspace slug
`cro`, project `CRO`, empty); 05 TheBrain file sync (all 8 brains in
`D:\Data\Brains\U01`; the Local API at `http://localhost:11522` lists
all 8 and returns each home Thought; TheBrain's "Start hidden when you
log in" is on); 06 Plane MCP connection (`plane-cro` reaches the local
Plane and lists only CRO; a test work item was created, read back and
deleted, 2026-11-06). `cro_index` embeds with `nomic-embed-text` through the
local Ollama container (`DECISIONS.md`, 2026-11-05).

**Where things live:** setups in `src\Infra\NN-name\` (`02-cro-index-
postgres`, `03a-ob1-local-brain`, `04-plane`; the folder names stay as
they are, Keith's call 2026-11-06), started by `src\Infra\up.cmd`.
Data under `D:\Data\CRO`. Secrets in .NET User Secrets on `src\CRO`
(`CRO:DbPassword`, the `Plane:*` keys including `Plane:ApiToken`, and
`TheBrain:ApiToken`). Published ports are on `127.0.0.1` only: OB1
8000, Plane 8090, `cro_index` 5433, Ollama 11434. Keith's own findings
that are not plans yet: `docs/Notes and Findings.md`.

**Connections (verified 2026-11-06 by project list and thought
count):**

| Connection | Points at | Note |
| --- | --- | --- |
| `plane-cro` | Local Plane, `localhost:8090`, workspace `cro` | One project, CRO |
| `plane`, `claude.ai Plane` | Cloud CreativeOS workspace | AUTHOROPS, JTKAELEN, INFRA, QFP |
| `open-brain` | Cloud OB1 | 93 thoughts, 2026-08-23 to 2026-10-20 |
| Local OB1 | `127.0.0.1:8000`, REST functions | No MCP connection. The C# client is Epic 1 Feature 02 |

The cloud `plane` entry stays until its work items are pulled into the
local Plane. That needs the local OB1 connection first (Keith,
2026-11-06).

**Next:** Epic 0 Features 07 (`cro_index` MCP), 08 (local DNS) and 09
(travel naming), each with User Stories in its
folder. A ping-only ASP.NET Core scaffold (`src/CRO/`, user-approved,
committed 2026-11-05) and its direction guide
(`docs/developer-before-you-code.md`) exist; build and runtime are not
verified.

**Resume after a reboot:** start Docker Desktop, run
`src\Infra\up.cmd`, then check `docker ps` and
`curl http://localhost:8090/api/instances/`. TheBrain should start
hidden at login; check `GET http://localhost:11522/api/brains` with
the `TheBrain:ApiToken` secret. That is the first real test of the
start-hidden setting (Feature 05, Story 02). All work through this
context refresh is committed, logged in `.journal/2026-11.md` and
pushed (2026-11-06); run `git status` to confirm. The curated
`.journal/journal.md` stops at the week of 2026-10-26; the next entry
is planned for the end of this week (Features 01-05 and later).

Settled, not re-narrated here — see `DECISIONS.md`: CRO never reads a
repository directly (2026-10-22); the developer-facing architecture
review package (`docs/developer-architecture-overview.md`) is
complete and current (2026-10-22).

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
  data: TheBrain Note-body search now works (confirmed 2026-10-22 —
  see "TheBrain Note-search re-test" below; the original 2026-10-11
  finding that it was unreliable is outdated); OB1 type classification
  skews heavily to "observation" and shouldn't drive routing; OB1
  doesn't deduplicate person/topic facets; OB1 relevance scores are
  soft, not a cutoff; getting a stable ID and ranked text from OB1
  requires two separate calls.
- Sensitivity tiers (`standard`/`personal`/`restricted`) gate what's
  returned, based on how private the *content* is — **not** on
  whether a specific person is named (corrected 2026-11-04; the real
  "Who Am I" TheBrain note mentions "my wife, Kittery" by name and is
  still `standard` — naming someone isn't itself sensitive). The two
  have been married ~36 years and share everything, so household data
  isn't walled off by person — the risk is their medical histories
  getting merged/confused, not one seeing the other's data.
  `restricted` = actual medical/financial-grade records, confirmed
  live to live in TheBrain's Filing Cabinet brain. Attribution (whose
  fact something is) is a separate, not-yet-modeled axis from
  sensitivity (how private it is). TheBrain's own `acType` field
  (confirmed live 2026-11-05) is a related but unreliable native
  "Private" signal — an input to this classification, never a
  substitute for it (see `docs/cro-index-schema.md`'s
  `thebrain_nodes.access_type`).

`cro_index`'s real schema (11 tables, settled through live
verification) lives in the Epic roadmap section below, not here — the
schema used to be sketched in this section too, but that sketch
(`nodes`, `chunks`, `edges`, `sync_state`) is now wrong and fully
superseded.

### Epic roadmap (restructured 2026-11-04 — supersedes the old
"Phase 1 plan" single-doc framing below; renamed Phase→Epic
2026-11-04 since these are organized as Epics, breaking down into
Features and eventually User Stories/PBIs — see `docs/phase-
roadmap.md`'s Plane tagging convention)

Full detail in `docs/phase-roadmap.md`, with each Epic detailed in
its own `docs/phase-N-plan.md` (file names unchanged for stable
history). Epic 0 and Epic 1 are detailed enough to move toward
prototyping; Epics 2–6 are named at the broad-stroke level only.

**Note:** there was also an older, separate 0-5 delivery plan
(`docs/README.md` §15, predates this Epic list) whose numbers
collided with these — marked superseded 2026-11-04; its real content
was folded into the correct Epic below. See `docs/phase-roadmap.md`'s
"Where the old plan's content went" for the full mapping.

0. **Epic 0 — Installs** (`docs/phase-0-plan.md`, added 2026-11-04):
   no CRO code, infrastructure only. Docker Desktop, a Postgres+
   pgvector container dedicated to `cro_index` (never shared, the
   same mistake that broke the old OB1-local instance), a fresh OB1
   Docker install (resolves the real unverified gap in what Epic 1
   assumed existed), a fresh Plane Docker install, and a manual
   BeyondCompare file sync bringing TheBrain's brains onto the laptop.
1. **Epic 1 — Bootstrap** (`docs/phase-1-plan.md`, approved
   2026-11-05, 8 Feature files, incl. 08 rebuild-safe user decisions):
   a single run, not continuous. Read
   TheBrain once, create or update matching OB1 + `cro_index` entries
   — including `chunks` and `edges`, not deferred to Epic 2 (resolved
   2026-11-04) — flag (never act on) Thoughts/notes that might need
   reorg: duplicate/orphan/stale/hub detection, a deferred
   embedding-based catch-all-hub and duplicate-neighborhood pass, and
   two more found live 2026-11-05 — misplaced-private content
   (TheBrain's own `acType` marker, confirmed unreliable on its own)
   and Note-embedded cross-brain `brain://` links (invisible to the
   `/graph` endpoint, need their own Note-body scan). TheBrain stays
   fully read-only this Epic — the earlier "Slice 2" write-support
   exception was moved out to Epic 4, not kept here. The cloud OB1
   transfer is deferred (2026-11-05).
2. **Epic 2 — Lookup + Plane** (`docs/phase-2-plan.md`, broad-stroke):
   the actual search/retrieval capability (with provenance and the
   serendipity-cap-2 rule, folded in from the old plan), standing
   resurfacing directives (also folded in — previously an unplaced
   gap), plus seeding Plane's CRO project (already installed in
   Epic 0) with 2-3 hand-added Work Items and indexing them.
3. **Epic 3 — Create/Update** (`docs/phase-3-plan.md`, broad-stroke):
   the ongoing version of Epic 1's one-time run — keeps OB1 and
   `cro_index` current as new things happen. Nearly all of its content
   (heterogeneous capture, reuse-or-create Thoughts, classification)
   is folded in from the old plan's "General capture" phase.
4. **Epic 4 — Reorg** (`docs/phase-4-plan.md`, broad-stroke): acts on
   Epic 1's flags for real — moving a Thought/Note between brains,
   resolving the real "Kittery exists in 2 brains, unlinked" case,
   plus restructure suggestions folded in from the old plan. This is
   the one place TheBrain write support happens.
5. **Epic 5 — External Gather** (`docs/phase-5-plan.md`,
   broad-stroke): a public HTTP ingest point for new entries, scanned
   and quarantined before anything reaches canonical storage.
6. **Epic 6 — Skill Hooks and Controlled Writes**
   (`docs/phase-6-plan.md`, new 2026-11-04, built entirely from the
   old plan's "Skill hooks and controlled project writes" phase): how
   a skill calls CRO for context and reports its own persistence
   decision back — CRO never auto-receives a skill's write.

Epics 0–3 together are the usable MVP. Epics 4–6 extend it.

Each Epic has a matching `docs/Epic N - Title/` folder (added
2026-11-04). Epic 0's is fully broken out into Feature files
(one folder per Feature, `Feature 01 - Docker Desktop\` through
`Feature 09 - Travel-Access Naming\`, each holding the Feature file
plus its `User Story NN` files; one Feature per install+test item in
`docs/phase-0-plan.md`); the other Epics have just a placeholder
`README.md` pointing back to their `phase-N-plan.md` for now.

(Repo-grounded retrieval is **not** an Epic — cancelled entirely
2026-10-22, see `docs/README.md` Section 3.1.)

Cross-cutting decisions that apply to every phase (language/stack,
schema, the developer-doc-review task) now live in
`docs/phase-roadmap.md` rather than being repeated per phase.
`docs/cro-index-schema.md` has the full current schema (11 tables,
`node_flags` added 2026-11-05) — not re-listed here to avoid this
file drifting out of sync with it again, the same reason the old
schema sketch had to be removed from this file once already.

### OB1 status

- Fork at `D:\Repos\KeithBarrows\OB1` is current with upstream
  (checked 2026-11-05: HEAD `238df6c`, 2026-09-10, same as the
  fork's `main` on GitHub). Its `origin` still points at upstream
  (`NateBJones-Projects/OB1`), not the user's fork. Capability survey
  from the 2026-10-16 fork review: `docs/ob1-integration-survey.md`.
  Live-checked upstream findings:
  `docs/Epic 0 - Installs/Feature 03 - OB1 Fresh Docker Install/Feature
  03 - OB1 Fresh Docker Install.md`.
- Currently in use by other tools (inference, carried from older notes,
  not checked 2026-11-06): a cloud-hosted instance, confirmed
  temporary, with very few of the available extensions/recipes
  enabled.
- The local OB1 install from Epic 0 Feature 03 is the real local
  instance. The old `ob1-local` Supabase instance (crashed Edge
  Runtime, Postgres shared with a weather-station project) is
  superseded and not used.
- Update and delete come from our own `update` and `delete` Edge
  Functions, not `enhanced-mcp` or upstream `rest-api` (both ruled
  out). Extensions worth enabling later, such as the household/CRM one
  already rescoped to attribution-tagging, not access-separation (see
  `DECISIONS.md` 2026-10-16), are catalogued in
  `docs/ob1-integration-survey.md`.
- Correction (2026-11-05, supersedes the 2026-10-22 note): OB1 CAN
  update and delete. `update_thought` exists in `enhanced-mcp`, in
  `integrations/update-thought-mcp`, and as `PUT /thought/:id` in
  `integrations/rest-api`. Delete exists as
  `integrations/delete-thought-mcp` (hard delete) and `DELETE
  /thought/:id` in `rest-api`. `enhanced-mcp` alone leaves delete out,
  waiting for a `deleted_at` column and `restore_thought`. The old
  claim "no delete in any build" was wrong. Full findings and
  sources: `docs/Epic 0 - Installs/Feature 03 - OB1 Fresh Docker
  Install/Feature 03 - OB1 Fresh Docker Install.md`.
- Hard rule (user, 2026-11-05): OB1 runs in Docker on the laptop and
  is never given cloud access for anyone, including cloud embedding
  calls. A local fully-offline recipe exists upstream
  (`recipes/local-brain-no-mcp`, Supabase compose + Ollama).
- Trusted boundary (user, 2026-11-05): every data store CRO installs
  (OB1, Plane, `cro_index`, TheBrain files) sits inside the trusted
  environment: the laptop, with LAN-only access to the future
  API/MCP. Being "in OB1" is not itself a reason to withhold content.

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
  the Epic 1 plan are updated to match the re-test. See `DECISIONS.md`
  2026-10-22 entry.
- Decided 2026-10-22: keep `cro_index`, but its job narrows. It no
  longer needs to be the only way to find Note text — TheBrain now
  does that itself. `cro_index` stays responsible for meaning-based
  (semantic) search and for combining TheBrain + OB1 results in one
  search, until TheBrain adds its own fuzzy/semantic search.
- OB1 was considered as the home for this fuzzy-search/sync job
  instead of `cro_index` — rejected 2026-10-22 on the grounds that OB1
  had no delete tool. That reason no longer holds (2026-11-05: OB1 can
  update and delete — see the correction under "OB1 status" and
  `DECISIONS.md`). The decision to keep `cro_index` is unchanged.

### Plane

- Confirmed self-hostable via Docker (official installer, free
  Community Edition, AGPL-3.0) — brings its own bundled Postgres
  (plus Redis, MinIO), never shared with `cro_index` or OB1's
  Postgres.
- Joins CRO as a third local backend, for tasks, on the same
  REST-not-MCP pattern as OB1. Installed in Epic 0 (one project named
  "CRO"); seeded with 2-3 hand-added Work Items and indexed in
  Epic 2.
- Work item fields confirmed live against a real Plane workspace:
  title, body (plain text preferred for chunking over the HTML
  version), status, labels/tags, optional start/end dates. The
  connected workspace's plan tier has no custom-property or native
  category support — category, priority (`Pri1`-`Pri5`), and severity
  (`Sev1`-`Sev5`) are carried as plain tags instead (see
  `docs/cro-index-schema.md`'s `plane_workitems` table).
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
- OB1 cloud-to-local migration — deferred 2026-11-05 (user: ignore
  the cloud OB1 for now).
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
continues. Code scaffolding in `src/CRO/` is user-approved
(2026-11-05); every further slice still follows the Approval
boundaries below.

## Active decisions

- The CRO index is disposable infrastructure, not a knowledge store.
- Local Postgres + `pgvector` — **plain Postgres, not Supabase**, for
  `cro_index` specifically (settled 2026-11-04): `cro_index` doesn't
  need Supabase's Auth/Realtime/Storage layers, only OB1 does.
- CRO-owned `cro_index` and `cro_runtime` storage must remain separate
  from OB1-owned storage.
- Retrieval combines exact text, semantic similarity, metadata, and
  relationship-aware expansion.
- Candidate TheBrain/OB1/Plane records are re-read live from their
  canonical owner before final use — never served from `cro_index`
  alone (corrected 2026-11-04: dropped "repository" from this rule —
  CRO never reads a repository at all, see the 2026-10-22 decision in
  `DECISIONS.md`).
- Serendipity is limited to one or two secondary results.
- TheBrain Thought titles use an approximately 80-character soft limit.
- Normal capture completion is represented by absence of `Incomplete`;
  there is no `Complete` tag.
- OB1-only thoughts are normal (OB1 holds some business-process
  information that exists nowhere else). The invariant is that every
  TheBrain/Plane node links to an OB1 node, not the reverse (decided
  2026-11-05).
- Bootstrap writes every node's full text to OB1, `restricted`
  included — OB1 is local-only inside the trusted boundary (decided
  2026-11-05).

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
  instead of a local-only dev server.
- **All setup and code live under `\src`, following the standard
  .NET repository layout (added 2026-11-05).** That includes
  infrastructure: Docker Compose files and the scripts that start them
  live in `src\Infra\`, one numbered subfolder per setup
  (`02-cro-index-postgres`, matching its Epic 0 Feature number), with
  `src\Infra\up.cmd` bringing them all up in order. Secrets use .NET
  User Secrets on `src\CRO` (key `CRO:DbPassword`), never a `.env`
  file or `.secrets\` folder. Do not create top-level `infra\` or
  similar folders.
- **Ports 80 and 443 are reserved (2026-11-06).** No CRO setup may
  publish them; they are kept for future projects. Every CRO service
  publishes on `127.0.0.1` at a higher port: OB1 gateway 8000, Plane
  8090, `cro_index` Postgres 5433. See `DECISIONS.md`.
- **Permanent hostname — resolved 2026-11-04, corrected 2026-11-04.**
  Not a per-machine `hosts`-file edit (doesn't scale once more
  subdomains exist — see below). Instead: a subdomain of `sol3.net` —
  the user's long-term **personal** domain, correctly distinct from
  `quantumfracturecreative.com` (the writing/business domain,
  already used that way for `vision.quantumfracturecreative.com` —
  not the right domain for CRO, a personal-infrastructure project).
  E.g. `cro.home.sol3.net`, resolved to the laptop's LAN IP by a small
  local DNS resolver (dnsmasq or Pi-hole — Pi-hole's own local-DNS UI
  doesn't support wildcards, so use dnsmasq directly if a wildcard is
  ever wanted) running **in Docker, on the laptop itself** —
  consistent with the laptop-only rule above. Chosen over `.home.arpa`
  specifically because a real owned-domain subdomain can get genuine,
  browser-trusted HTTPS certificates via a DNS-01 challenge;
  `.home.arpa` never can. A made-up TLD (`.lan`, `.home`) was ruled
  out — those can leak lookups to the public DNS root and
  occasionally collide with something real. Future web sites get the
  same subdomain treatment, not a one-off special case for CRO. Added
  to `docs/phase-0-plan.md` as an explicit install step. Not yet
  implemented — this is the chosen approach, not confirmation it's
  running.
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
  (settled in `docs/cro-index-schema.md`'s `chunks` table, corrected
  2026-11-04 — this used to point at a "Current state" section in
  this file, but that detail lives in the schema doc instead) stays
  CPU-only anyway, not because the base GPU is forbidden, but because
  a model this small gains nothing from one — the pinning rule is for
  any future dependency that *would* actually benefit from a GPU.
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

- What is the final validation schema for skill `cro_context` blocks?
- How should standing resurfacing directives be stored? (trigger
  mechanism is settled — see Current state; storage/data model is
  not; now homed in Epic 2, see `docs/phase-2-plan.md`'s Features)
- What OIDC provider and account-allowlist mechanism should gate the
  public ingest site?
- What is the migration plan for moving OB1 from cloud to
  internal-only hosting? (Deferred 2026-11-05.)
- Does Plane content also flow into TheBrain, or stay a separate lane?
- What UI direction fits the dashboard at scale — is a local-graph
  view (one item + direct connections) the answer to the open doubt
  about list/grid UIs past a few hundred/thousand items?
- Which OB1 setup wins in Epic 0 Feature 03, and does upstream
  `rest-api` run on the local `local-brain-no-mcp` stack with Ollama
  embeddings (no cloud)? Unverified.
- Where does the Epic 1 rebuild-safe user-decisions export file live
  (path and format)?
- After the TheBrain sync: search the six indexed brains for an
  ordinary Thought with 30+ links (Epic 1 test 4's positive case).
  Rolodex's child count is "100+" in the docs but about 94 by the
  user's recollection (2026-11-05) — unverified either way.

## Next checkpoint

Epic 0's installs (`docs/phase-0-plan.md`; Feature 03's OB1
trials first), then Epic 1's actual bootstrap code (approved
2026-11-05), both laptop-only work. Epics 2–6
(`docs/phase-roadmap.md`) are broad-stroke only and don't need
approval yet — each needs its own detailed planning pass first.

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

2026-11-06 by Claude Sonnet 5.5 (after Epic 0 Feature 06): recorded
Feature 06 as done, replaced the Next list, and added the connections
table (which Plane and OB1 connection points where, and that the local
OB1 has REST only). Epic 1 Feature 02 now names the C# REST client for
the local OB1.

2026-11-06 by Claude Sonnet 5.5 (working-context-2-shape, before a
machine restart): replaced "Outcome now" with where we are, what is
done (Epic 0 Features 01-05), where things live, what is next, and
how to resume after a reboot; replaced the stale "OB1 status" bullets
(old `ob1-local` superseded, `enhanced-mcp` not used, own update and
delete functions); fixed a stale Feature 03 path. Recorded earlier
today: ports 80 and 443 reserved, Features 01 and 05-09 moved into
Feature folders with 28 User Stories, Keith's findings file.

2026-11-05 by Claude Sonnet 5.5: recorded the `\src`-only layout rule
and the User Secrets decision while starting Epic 0. Feature 01
(Docker Desktop) is done; Feature 02's Postgres container runs from
`src\Infra\02-cro-index-postgres`.

2026-11-05 by Claude Sonnet 5.5 (working-context-2-shape, after the
Epic 1 plan review): corrected the OB1 facts (it can update and
delete; fork is out of date; local-only, no cloud), marked the cloud
OB1 transfer deferred, recorded OB1-only thoughts and full-text-to-OB1
as active decisions, updated Epic 1 to 8 Features, replaced the stale
"building is not in scope" Working mode, and added the open items
from the review (Feature 03 trials, export-file location, the 30+
link search, the Rolodex count). Recorded the `src/CRO` scaffold and
the application-shape decision in DECISIONS.md.

2026-11-05 by Claude Sonnet 5: Epic 1 (Bootstrap) approved — updated
"Outcome now," the Epic roadmap's Epic 1 entry, and "Next checkpoint"
to say so. Added two Features found live during the same review
(misplaced-private content detection via TheBrain's `acType` field;
Note-embedded cross-brain `brain://` link detection), both now in
`docs/cro-index-schema.md` (`node_flags`, `thebrain_nodes.access_type`,
`brains.is_private_home`) and `docs/Epic 1 - Bootstrap/` (Features 06,
07). Removed this file's stale 6-of-11-table schema list (replaced
with a pointer to the schema doc, to stop it drifting again) and added
the `acType`-as-input-signal correction to the sensitivity-tier
description.

2026-11-04 by Claude Sonnet 5, second pass: fixed a punch-list left
by a laptop-side session after pulling this branch — removed 3 dead
Active-decisions lines (CRO reading repos, repo writes, Note-body
fetching, all contradicted by later decisions), corrected the
Retrieval-model line claiming Note-body search is unreliable (fixed
2026-10-22, this just never got updated), removed a dead open
question about a repository indexing allowlist (no repo adapter
exists), fixed a dangling "see Current state below" reference, and
added the `docs/Epic N - Title/` folders to the roadmap summary.
**Not changed:** a `D:\Repos` path hardcoded in the OB1 fork line —
confirmed with the user that `D:\Repos` is the correct, intended
convention for every machine including the laptop, not something to
rewrite per-machine.

2026-11-04 by Claude Sonnet 5 (working-context-2-shape): removed the
`cro_index` schema sketch that had gone factually wrong (it still
listed `nodes`/`chunks`/`edges`/`sync_state` after today's full
10-table redesign — the Epic roadmap section already has the real
one), corrected the sensitivity-tier description (naming someone
isn't itself sensitive), expanded the thin Plane section with today's
confirmed fields and the category/priority/severity-as-tags decision,
compressed "Outcome now" down to present-state facts instead of
re-narrating decisions already recorded in DECISIONS.md, and fixed a
few leftover "Phase 1 plan" phrasings to "Epic 1"/"Epic roadmap."

2026-11-03 by Claude Sonnet 5: added the hard constraint that CRO
runs on the laptop (not the desktop), with its API/MCP exposed on
the LAN and locally, specifically so nothing needs syncing from the
laptop while traveling. Resolved the now-answered laptop-sync open
question and deferred item to match.

2026-10-20 by Claude Sonnet 5, reshaping this file from a dated diary
into a topic-grouped description of present state (see DECISIONS.md
for the settled decisions moved out of here).
