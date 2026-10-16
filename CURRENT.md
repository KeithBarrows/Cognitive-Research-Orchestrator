# Current project state

## Outcome now

Prepare and approve the bounded Phase 1 plan for read-only,
repository-grounded context recall. Do not begin runtime implementation
until that plan identifies the first vertical slice, acceptance tests,
and implementation technology.

## Current state

- CRO is a local-first, MCP-facing orchestration layer. Project
  repositories own project work and canon; TheBrain owns durable
  knowledge, evidence, Notes, attachments, and meaningful graph
  relationships; OB1 owns ideas, observations, tasks, references,
  person notes, and other semantic thought history; CRO owns
  orchestration plus bounded, rebuildable operational state.
- TheBrain, OB1, and repository-adapter capability discovery is
  complete. Architecture documentation reflects the 2026-10-11 handoff
  and addendum, plus a new top-level ownership diagram
  (`docs/architecture/07-ownership-split.mmd`, linked from README).
  Runtime implementation has not started.
- Repository startup uses the shared `D:\Repos\.ai-config\startup.md`
  loader via `CLAUDE.md`; migration from the old local `.ai` loader is
  complete. The working tree still contains unrelated pending changes
  (`.gitignore`, journal files, `README.md`, `CONTEXT-MAP.md`,
  `.mcp.json`) — not a clean implementation baseline.
- **Working mode:** for CRO project work, the assistant's role is
  Business Analyst — gather requirements and map relationships between
  broad-scoped ideas. No schema or architecture work until the user
  explicitly asks for it.
- **Retrieval model (draft, not approved):** OB1 is a fast first-pass
  SEARCH layer, used at both save and retrieve time — not a save-time
  capture-then-promote pipeline. A hit in OB1 is a pointer into
  TheBrain, where the full depth (Notes, files, images, associative
  chain) lives. Retrieval must walk the TheBrain graph both down
  (specific children) and up (broader parent subject). Live-verified
  against the user's real Brain ("Growth") and real OB1 data (91
  thoughts): TheBrain Note-body search is unreliable; OB1 type
  classification skews heavily to "observation" and shouldn't drive
  routing; OB1 doesn't deduplicate person/topic facets; OB1 relevance
  scores are soft, not a cutoff; getting a stable ID and ranked text
  from OB1 requires two separate calls.
- **cro_index schema (draft, not implemented):** Supabase/pgvector
  tables `nodes`, `chunks`, `edges`, `sync_state`, sized against a
  645,000-item scale target (Jerry's Brain). Saved to session memory.
- **Capture flow named, not designed:** a "please remember [link]"
  command — an AI agent (likely OpenRouter) fetches and distills a
  page, then CRO decides whether to save a new OB1 thought or append
  to an existing TheBrain Thought, then updates `cro_index`. Email
  named as a second ingestion source.
- **Proactive retrieval, newly identified:** skills must be able to
  pull CRO context automatically while running, not only when asked
  (worked example: a chapter-outline skill surfacing EDS research
  tagged to both the user's wife and the character Jennifer Rose).
  This also requires standing resurfacing directives — user-set "watch
  for X" rules CRO remembers and triggers unprompted — a new concept
  with no design yet.
- **EDS/Jennifer Rose trace (completed):** fiction-side canon is rich
  (character card + dedicated medical worldbuilding card, 40 files).
  Real-world side is untracked — `pers-health` holds only the user's
  own data; his wife Kittery's EDS diagnosis exists only inside
  fiction-research notes in `pers-writing/Engrams` (captured twice, no
  dedup), alongside an informal, unenforced privacy boundary already
  written down there.
- **Infrastructure scope, named and deferred:** a public ingest site
  (OIDC login, user-controlled account allowlist, anti-spoofing) for
  capturing items while away from home; the full stack running 100% on
  one machine via Docker-hosted Supabase (already running); OB1 moving
  from its current cloud hosting to internal-only (unscheduled
  migration); a laptop-sync method for travel, staying fully local;
  future health-device ingestion (Oura, GuavaHealth, Google Health),
  each undesigned.
- **OB1's real scope is much larger than the 6 MCP tools tested, and a
  prior plan for 3 of the above items already exists.** OB1
  (`D:\Repos\KeithBarrows\OB1`) is Nate B. Jones's open-source "Open
  Brain": one Postgres/pgvector database plus extensions (Household
  Knowledge, Home Maintenance, Family Calendar, Meal Planning,
  Professional CRM, Job Hunt), recipes (Gmail/Google Activity/chat-
  export imports, dedup, digests, a proactive "Life Engine" assistant),
  business-analyst-grade skills (competitive analysis, deal memos,
  financial model review), and a Kubernetes self-hosted deployment
  option. Its own `.planning/PROJECT.md` and `STATE.md` (dated
  2026-06-22, confirmed still accurate 2026-10-16 — nothing has
  changed) already scoped 3 of the infrastructure items above as
  "Goals": Goal 1 (move OB1 to local Docker) was attempted and
  abandoned — local kept breaking, so the user fell back to the
  cloud-hosted OB1 currently in use, with very few of the available
  extensions/recipes enabled; Goal 5 (self-host the 12-Week Execution
  Board, exported from Lovable, into `QFCG/qfcg-planning`, running on
  local Supabase) was never executed; Goal 2 (Gmail/Calendar
  integration via `recipes/gmail-smart-pull`) was never executed. These
  are the authoritative prior plans for those 3 items — reconcile
  against them rather than redesigning from scratch. Confirmed
  2026-10-16: nothing has changed on this plan since June.
- **The OB1 fork (`D:\Repos\KeithBarrows\OB1`) was synced with its
  upstream (`NateBJones-Projects/OB1`) on 2026-10-16** (116 files,
  ~17,400 lines, not touched since June). Changes that matter for CRO:
  (1) `update-thought-mcp` and `delete-thought-mcp` now exist as
  optional integrations with dedicated safety skills — update/delete
  are real now, just not installed in the user's live cloud instance;
  (2) a formal "Ingestion Metadata Contract"
  (`docs/ingestion-metadata-contract.md`) now defines exactly what
  every importer should write per captured thought — `source_type`,
  `importer_name`, `input_hash`, `content_fingerprint` (for dedup),
  `sensitivity_tier`, and a `provenance` object — CRO's "please
  remember [link]" capture flow should adopt this contract rather than
  invent its own; correction: `enhanced-mcp`'s "deprecate and version
  rather than delete" line is the OB1 maintainer's own independently
  stated preference (quoted directly from their PR #127 closure), not
  something borrowed from or by CRO's own `Incomplete`-tag rule — two
  separate projects landing on the same idea coincidentally, not one
  influencing the other; (3) `enhanced-mcp` and `rest-api` integrations exist,
  a richer surface than the 6 tools `docs/capability-matrix.md`
  tested; (4) a new browser capture extension pulls content directly
  from open ChatGPT/Claude/Gemini tabs — a capture channel distinct
  from the "please remember [link]" flow.
- **`enhanced-mcp` (part of the same 2026-10-16 sync) is a second,
  optional OB1 server — 13 tools instead of the 4-6 tested — and it is
  targeted at the future local install, not the current cloud OB1
  instance.** The user confirmed 2026-10-16 the cloud instance is
  temporary and not worth upgrading; this capability is scoped for
  when Goal 1 (local Docker OB1) actually happens. What it adds:
  server-side `sensitivity_tier` (`standard`/`personal`/`restricted`)
  with restricted content blocked from cloud capture outright — a real
  enforcement mechanism for the Kittery/EDS privacy boundary, instead
  of an informal unenforced note; automatic SHA-256 content-fingerprint
  dedup on capture, fixing the "captured twice, no dedup" problem found
  live in the user's actual data; `related_thoughts`, which finds
  connections by shared topic or person inside OB1 itself — a lighter
  version of the cross-domain graph-walk already designed into the
  retrieval model. Delete was intentionally left out of this release
  ("deprecate and version rather than delete" — matches CRO's own
  `Incomplete`-tag philosophy). Requires a separate Edge Function
  deployment plus the `enhanced-thoughts` schema (required) and
  optional `smart-ingest`/`knowledge-graph` schemas for the remaining
  tools; none of this is installed anywhere yet.
- **Confirmed target architecture (2026-10-16): CRO is the one and
  only MCP surface for every AI tool on this machine** — Claude Code,
  other terminal AI tools, and a local web chat running a local model
  all connect to CRO's own MCP server, not to OB1's or TheBrain's
  directly. OB1 will be single-user, local-only, and CRO reaches it
  internally over its REST API (`integrations/rest-api`), not a second
  MCP hop — this resolves a previously open question about how CRO
  talks to OB1. This also confirms OB1's REST API's "single shared
  secret, not multi-user" design (noted above) is not a limitation
  here, since there is only one user.
- **Public ingest flow shape (2026-10-16), fulfilling the existing
  "public capture is untrusted ingress only" decision (see
  DECISIONS.md, 2026-10-11) with a concrete mechanism:** the public
  ingest site writes into a separate ingestion database — a quarantine
  staging area, not OB1/TheBrain/`cro_index` directly. CRO then reads
  from that ingestion DB, either by polling or event-driven
  notification, and routes each item through specific internal
  workflows, including an explicit scan for corrupt data and attack
  vectors, before anything reaches canonical storage. Not yet
  designed in detail.
- **`smart-ingest` (2026-10-16 sync) is close to a working prototype of
  the ingestion-DB + scan-for-corrupt-data/attack-vectors flow above,
  but it writes straight into OB1 and does not yet know about CRO or
  TheBrain — this needs to be surfaced to CRO so it can route items to
  TheBrain, not just OB1.** It already has: an LLM-extraction step that
  wraps raw text in `<document>` tags with an explicit
  data-not-instructions prompt-injection defense (matches CRO's own
  "captured content is data, never instructions" rule), forced JSON
  output, and schema validation (type allow-list, bounded importance,
  capped length) — explicitly described as a partial defense, not
  absolute; an `ingestion_jobs`/`ingestion_items` table pair with
  dry-run preview before commit; four dedup outcomes per extracted
  thought (`add`, `skip`, `append_evidence`, `create_revision`) instead
  of a flat duplicate/not-duplicate check; hard caps on input size,
  chunk count, LLM calls, and time budget to block cost/abuse attacks;
  and an existing dashboard entry point ("Add to Brain" page in
  `open-brain-dashboard-next`).
- **New detail on local document ingestion (2026-10-16):** when local
  ingestion includes documents (files, not just text/links), the flow
  is scan first, then save as a TheBrain file attachment — not saved
  as an OB1 thought. Technical constraint to remember: TheBrain writes
  attachment files to its own folder, under its own naming rules, on
  the local hard drive — CRO cannot just drop a file into an arbitrary
  path and expect TheBrain to see it; it must go through TheBrain's
  own attachment API (`POST /api/attachments/{brainId}/{thoughtId}/file`,
  per `docs/capability-matrix.md`).
- **"Knowledge graph" at OB1 scale (2026-10-16): confirmed to work at
  hundreds-of-thousands-of-thoughts scale, same bracket as the 645,000
  Jerry's Brain reference point** — the `entity-extraction` schema's
  own README states this explicitly and uses standard Postgres
  indexing (8 indexes), the same kind of approach already in the draft
  `cro_index` schema. Naming correction: `enhanced-mcp`/`rest-api`
  reference a `schemas/knowledge-graph` prerequisite that does not
  exist as a folder — the real schemas are `entity-extraction`
  (entity-to-entity edges: `works_on`, `uses`, `member_of`) and
  `typed-reasoning-edges` (thought-to-thought edges: `supports`,
  `contradicts`, `evolved_into`, `supersedes`, `depends_on`, plus
  time-decay so old relationships age out without deletion) — good
  prior art for `cro_index`'s own `edges` table, which currently has
  no decay concept. Both are OB1-side only (thought-to-thought), not
  TheBrain content. All of this lives in the one upstream repo,
  `https://github.com/NateBJones-Projects/OB1` (the extensions,
  recipes, skills, schemas, and integrations reviewed this session are
  all part of that single source).
- **`recipes/ob-graph` (2026-10-16): the manual counterpart to
  `entity-extraction` — you build the graph by hand via 10 MCP tools**
  (`create_node`, `create_edge`, `traverse_graph`, `find_path`, etc.),
  rather than automatic extraction from thought content; the two are
  independent, install either/both/neither. Scale is operation-
  specific, not one flat number: general use is fine through
  "thousands of nodes"; full path-traversal (`traverse_graph`, which
  enumerates every possible path) needs an added confidence-weight
  filter to prune low-value edges once past 100,000 edges — a real
  constraint `entity-extraction`'s simpler lookup queries didn't have,
  worth remembering against the 645,000-item Jerry's Brain scale
  target. No external graph database — two Postgres tables plus a
  recursive-CTE and an iterative-BFS SQL function, inside the free
  Supabase tier. Inconsistency noted: this recipe's `delete_node` /
  `delete_edge` tools do hard deletes with CASCADE, no soft-delete or
  revision — the opposite of the independent "deprecate and version"
  preference found in `enhanced-mcp` (see correction above: both are
  OB1's own choices, not CRO's).
- **`recipes/entity-wiki` (2026-10-16): synthesizes every thought
  linked to one entity into one LLM-written wiki page** (Summary, Key
  Facts, Timeline, Relationships, Open Questions) — atomic thoughts
  stay the source of truth, the wiki is a regenerable cached view, not
  a replacement. **Unresolved contradiction, not mine to settle:** its
  own README says it's blocked — the `entity-extraction` schema/worker
  it depends on are "not yet merged into OB1 `main`" — but that schema
  and worker already exist in `main` as of today's sync. Likely just a
  stale warning the PR author forgot to remove, but this is a repo
  fact, not a live-database fact — verify directly before trusting
  this recipe runs. **Pattern directly relevant to CRO's own retrieval
  design:** storing a synthesized summary back as a searchable thought
  causes search pollution — a summary restating many facts tends to
  out-rank the original atomic facts it was built from, since it's
  longer and more "on-topic." Their own mitigation (an
  `exclude_from_default_search` metadata flag) is, by their own
  admission, "a convention, not an enforcement" — the read side has to
  actively honor it. CRO's capture/retrieval design should treat any
  future distilled/summary content the same cautious way. Scale: fine
  through "a few thousand entities"; past 10k the batch-candidate
  lookup "dominates the run," scaling linearly, until a documented
  faster RPC ships by default. Cost: ~$0.01-0.02 per entity page,
  ~$0.25-0.50 for a batch of 25.
- **Dashboard requirement, named and deferred:** a holistic dashboard
  bundling CRO activity with actual writing/coding production,
  migrating an existing Loveable-built dashboard (likely
  `vision-board-builder`) rather than starting fresh, rehosted on the
  local one-box stack. A separate, explicitly deferred thread: which
  parts (if any) are publicly visible.
- **Full OB1 integration sweep completed 2026-10-16, written up in
  `docs/ob1-integration-survey.md`** (not repeated here in full). Top
  findings: a complete self-hosted reference build
  (`zebras/open-brain-self-hosted-guide.md`) closely matches the draft
  `cro_index` schema; `recipes/local-brain-no-mcp` is close to a
  ready-made blueprint for the already-decided "OB1 via REST, one
  machine" architecture; `schemas/agent-memory` + its API is a
  near-complete working model for CRO's two undesigned concepts
  (proactive skill-pull, standing resurfacing directives);
  `recipes/gmail-smart-pull` is a real pattern for the deferred
  email-ingestion item. **Correction on household data:** no access
  separation is needed between the user and his wife Kittery (married
  ~36 years, share everything) — the actual need is just an
  attribution tag on facts specifically hers, so their medical
  histories don't get merged, not a scoped-access boundary like the
  household extensions suggested.
- **Sequencing decided (2026-10-16):** dashboard is parked — lowest
  priority. Ingest gets real attention, not an afterthought. The
  retrieval model + `cro_index` schema are the first vertical slice,
  given how much independent validation they now have from the OB1
  integration survey.
- **New bootstrap step added to the order of operations:** before
  anything else runs, a one-time raw read of the user's TheBrain(s) to
  seed the new local OB1, plus a one-time read of the existing cloud
  OB1's thoughts, transferred into the new local OB1. Single pass, not
  an ongoing sync. Not yet designed.
- **Standing-directive mechanism clarified (2026-10-16):** it is not a
  separate always-on watcher. It rides inside the same context-pull
  every skill already needs for the proactive-retrieval flow — flows
  #3 and #4 are one mechanism, not two. A directive is checked
  whenever a relevant skill runs, not polled independently.
- **Home Automation (Home Assistant, home-assistant.io) is newly
  in-scope (2026-10-16)**, reversing the prior exclusion (see
  `CONTEXT-MAP.md`). Framed by the user as part of running the
  homestead and an eventual Alexa replacement. Cursory check only:
  Home Assistant has native MCP support as of its 2026.10 release,
  plus REST/WebSocket APIs and community add-ons exposing its full API
  surface as MCP tools — looks compatible with CRO's "CRO is the sole
  MCP surface" decision. Parked for a dedicated future pass, not
  designed.
- **Local `ob1-local` Supabase instance inspected directly (2026-10-16)
  — confirms almost nothing made it in.** Containers: database layer
  is up (37h since last restart); the Edge Runtime (the piece that
  actually serves the MCP server) crashed 2 months ago and has not
  restarted — this is why "local kept breaking." Database contents:
  only the bare getting-started schema (`thoughts` table, `pgvector`,
  HNSW index, content-fingerprint dedup, RLS), matching the schema
  already validated elsewhere; zero add-on schemas installed
  (`enhanced-thoughts`, `entity-extraction`, `smart-ingest`,
  `agent-memory` — none present); one row of data, and it is the
  getting-started guide's own tutorial example, not real captured
  data. **New concern:** this Postgres instance is shared with an
  unrelated weather-station project's tables in the same `postgres`
  database — not a clean, dedicated database to build the real
  migration on top of.

- **Phase 1 plan drafted (2026-10-16), written up in
  `docs/phase-1-plan-draft.md`** — all 5 items `CURRENT.md`'s "Next
  checkpoint" requires now have content: first slice is TheBrain/OB1
  retrieval (repo-grounded retrieval deferred to a second slice);
  language is C#/.NET, Kestrel, minimal API endpoints (no controllers),
  vertical slice organization, MediatR and Mediator both kept open for
  the CQRS band (CQRS/ES used where it fits, not mandated),
  FluentValidation, Serilog to the already-running local Seq container,
  Npgsql; schema boundary is the draft `cro_index` schema; 8 acceptance
  tests drafted, with the TheBrain-to-`cro_index`-and-OB1 bootstrap
  data flow as the first one that must pass before anything else is
  validated; an explicit exclusions list is drafted. **This is still a
  draft, not yet formally approved as the Phase 1 plan** — the user has
  not yet signed off per the "Next checkpoint" criteria.

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

- Which implementation language and MCP SDK should Phase 1 use?
- What is the first end-to-end read-only acceptance scenario?
- What initial PostgreSQL schema should hold `cro_index` and
  `cro_runtime`? (draft direction proposed 2026-10-15 — see Current
  state)
- What chunking and ranking policy is sufficient for the first slice?
  (draft direction proposed 2026-10-15 — see Current state)
- What is the final validation schema for skill `cro_context` blocks?
- Which repository artifact types enter the first indexing allowlist?
- How should standing resurfacing directives (user-set "watch for X"
  rules) be stored and triggered? Newly identified 2026-10-15 — not yet
  designed.
- What OIDC provider and account-allowlist mechanism should gate the
  public ingest site?
- What is the migration plan for moving OB1 from cloud to
  internal-only hosting?
- What sync/replication method keeps a laptop copy of the full stack
  local-only?

## Next checkpoint

The user approves a Phase 1 implementation plan containing:

1. the first vertical slice;
2. implementation language and dependencies;
3. initial schema boundaries;
4. acceptance tests;
5. explicit exclusions.

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

2026-10-16 by Claude Sonnet 5, after a full OB1 integration sweep
(written up in `docs/ob1-integration-survey.md`), deciding the build
sequence (retrieval model + `cro_index` schema first, dashboard
parked, ingest prioritized, a new one-time TheBrain/cloud-OB1
bootstrap step added), clarifying the standing-directive mechanism,
bringing Home Automation (Home Assistant) into scope, directly
inspecting the local `ob1-local` Supabase instance (schema only, no
add-ons, no real data, API layer dead, shares a database with an
unrelated project), and drafting a full Phase 1 plan
(`docs/phase-1-plan-draft.md`) covering all 5 "Next checkpoint" items,
not yet formally approved.
