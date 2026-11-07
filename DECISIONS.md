# Decision history

## 2026-10-11 — Canonical ownership and CRO storage boundary

**Status:** Active

**Decision:** Project repositories own project work and canon. TheBrain
owns durable knowledge and evidence. OB1 owns semantic thoughts. CRO owns
orchestration plus bounded operational and rebuildable state.

**Replaces:** The earlier three-system design that used Karakeep and
risked making CRO another knowledge store.

**Reason and evidence:** Approved design handoff, design addendum, and
ADR 0001.

**Affected unfinished work:** Every runtime data model, adapter, capture
flow, and retention policy must preserve this ownership boundary.

**Revisit when:** A new canonical system is explicitly approved or an
existing owner cannot meet a verified requirement.

**Rollback path:** Supersede this ADR through an explicit architecture
decision. Do not drift ownership through implementation convenience.

**Recorded by:** Codex from user-approved architecture, verified against
the repository documentation.

---

## 2026-10-11 — Use a disposable local hybrid retrieval index

**Status:** Active

**Decision:** CRO may index repository content, TheBrain titles and
Notes, attachment metadata or extracted text, canonical identifiers,
hashes, chunks, and embeddings. The index finds candidates; CRO fetches
live authoritative content before final use.

Local PostgreSQL/Supabase with `pgvector` is the preferred direction.
CRO-owned schemas or databases remain separate from OB1-owned storage.

**Replaces:** The tentative SQLite direction and any assumption that
native TheBrain search can retrieve Note bodies reliably.

**Reason and evidence:** TheBrain capability discovery found Note-body
search unreliable. The approved addendum requires exact, semantic,
metadata, and relationship-aware retrieval.

**Affected unfinished work:** Phase 1 schema, indexing, chunking,
ranking, synchronization, and hydration design.

**Revisit when:** A measured prototype shows that another local
technology better meets the same ownership and rebuildability rules.

**Rollback path:** Rebuild the disposable index in another local
technology. Canonical content remains unchanged.

**Recorded by:** Codex from the approved addendum and verified capability
matrix.

---

## 2026-10-11 — Keep sensitive systems local and public capture untrusted

**Status:** Active

**Decision:** CRO, TheBrain, OB1, project repositories, and sensitive
derived indexes remain inside the trusted home environment. A future
public capture service may provide only a minimal authenticated inbound
queue. It receives no trusted retrieval access or inbound control of
home systems.

Captured content is data, never instructions. Future ingestion must use
quarantine, validation, restricted parsing, capability isolation, and
SSRF defenses.

**Replaces:** Any design that directly exposes CRO, MCP, TheBrain, OB1,
or local databases to the public internet.

**Reason and evidence:** The approved design addendum identifies private
health, tax, financial, household, and other sensitive data as
local-only.

**Affected unfinished work:** Future remote capture, networking,
authentication, quarantine, extraction, and deployment design.

**Revisit when:** Remote capture enters an approved implementation phase.

**Rollback path:** Disable the cloud queue without affecting local
knowledge systems.

**Recorded by:** Codex from the user-approved design addendum.

---

## 2026-10-11 — Complete Phase 0 and begin with read-only retrieval

**Status:** Active

**Decision:** TheBrain, OB1, and repository-adapter capability discovery
is complete. The first runtime phase will be a bounded, read-only,
repo-grounded context-recall slice. Repository writes and future platform
systems remain deferred.

**Replaces:** The Phase 0 state in which repository-adapter discovery was
still pending.

**Reason and evidence:** Live capability testing is recorded in
`docs/capability-matrix.md`. The matrix defines verified fallbacks and
the initial implementation boundary.

**Affected unfinished work:** Select the implementation language, define
the first vertical slice and schema, and write acceptance tests before
runtime implementation.

**Revisit when:** The first read-only vertical slice has an approved plan
or new capability evidence changes the boundary.

**Rollback path:** Return to design work without changing canonical data.

**Recorded by:** Codex after the 2026-10-11 capability-discovery audit.

---

## 2026-10-16 — CRO is the sole MCP surface on this machine

**Status:** Active

**Decision:** Every AI tool on this machine (Claude Code, other
terminal AI tools, a future local web chat running a local model)
connects to CRO's own MCP server, not to OB1's or TheBrain's directly.
OB1 and Plane are each single-user, local-only, and reached by CRO
over their own REST APIs — not a second MCP hop.

**Replaces:** An open question about how CRO talks to OB1.

**Reason and evidence:** Keeps one access-control point instead of
several, and resolves OB1's own REST API design ("single shared
secret, not multi-user") as a non-limitation, since there is only one
user.

**Affected unfinished work:** Every adapter and capture-routing design
must assume CRO is the only MCP endpoint; OB1/Plane integrations are
REST clients, not MCP clients.

**Revisit when:** A second real user of this machine's AI tooling
exists, or OB1/Plane drop REST API support.

**Rollback path:** Expose OB1 or Plane's own MCP servers directly;
revisit the single-access-point guarantee explicitly if so.

**Recorded by:** Claude Sonnet 5, from the 2026-10-16 session.

---

## 2026-10-17 — Plane joins CRO as a third local backend, for tasks

**Status:** Active

**Decision:** Plane (self-hosted via Docker, free Community Edition,
AGPL-3.0) is a third CRO-managed backend, alongside TheBrain and OB1,
scoped to tasks. Reached via its own REST API, same pattern as OB1.

**Replaces:** No prior task-management backend was decided.

**Reason and evidence:** User confirmed Plane can run fully local via
Docker; task management was an unaddressed gap in the two-backend
design.

**Affected unfinished work:** Whether Plane content also flows into
TheBrain, or stays a separate lane, is still open (see CURRENT.md).

**Revisit when:** The Plane-TheBrain data-flow question above is
resolved, or Plane proves unworkable self-hosted.

**Rollback path:** Drop Plane; route tasks back through OB1 thoughts
only.

**Recorded by:** Claude Sonnet 5, from the 2026-10-17 session.

---

## 2026-10-18 — OB1-universal-coverage: everything routes through CRO after bootstrap

**Status:** Active

**Decision:** After the one-time bootstrap, nothing writes to
OB1/Plane/TheBrain directly. A skill sends a capture to CRO; CRO
classifies it (task → Plane, thought → TheBrain), creates/updates the
connected Plane task and/or TheBrain thought, and always
creates-or-updates a matching OB1 thought — never a duplicate when new
supporting data arrives for something already captured.

**Replaces:** An earlier open question ("how does OB1 stay in sync as
new items get created in Plane or Vision Board later, not just at
bootstrap").

**Reason and evidence:** User requirement, stated directly while
reviewing the LCARS mockups: OB1 should hold a thought for everything
across every backend, not just explicit captures.

**Affected unfinished work:** The capture flow design (see CURRENT.md)
must implement this routing and the update-not-duplicate rule.

**Revisit when:** The capture flow is actually implemented and this
routing proves wrong in practice.

**Rollback path:** Allow direct writes to OB1/Plane/TheBrain again for
specific flows, case by case.

**Recorded by:** Claude Sonnet 5, from the 2026-10-18 session.

---

## 2026-10-16 — Household data uses attribution tags, not access separation

**Status:** Active

**Decision:** Facts specifically belonging to the user's wife Kittery
(e.g. her EDS diagnosis) get an attribution tag, not a scoped-access
boundary. No system wall separates her data from his.

**Replaces:** An initial assumption, drawn from OB1's own
household/CRM extensions (a scoped-access, separate-server pattern,
built for giving a spouse access to only their own data).

**Reason and evidence:** User correction: married ~36 years, share
everything; the real risk is their two medical histories getting
merged/confused with each other, not one seeing the other's data.

**Affected unfinished work:** Any future household/CRM-style schema
work should tag ownership, not gate access.

**Revisit when:** A second household member with a genuine need for
separate access joins the system.

**Rollback path:** Add scoped access later if that need appears;
tagging data loses nothing in the meantime.

**Recorded by:** Claude Sonnet 5, from the 2026-10-16 OB1 integration
survey.

---

## 2026-10-17 — Network exposure boundary: internal home network only

**Status:** Active

**Decision:** CRO, web UIs, and MCP artifacts may be exposed on the
internal home network (reachable from a phone or laptop on the same
WiFi) — this is fine and intended. They must never be exposed through
the router to the public internet.

**Replaces:** Sharpens, without changing, the existing "never expose
to the public internet" hard constraint from the 2026-10-11 decision
above.

**Reason and evidence:** User clarified routine at-home access needs
no public door; only genuinely away-from-home access does, through the
still-undesigned public ingest site or the laptop-clone path.

**Affected unfinished work:** Any local web UI or dashboard can bind to
the LAN without needing the public-ingest auth layer first.

**Revisit when:** A laptop-sync or travel-access design is approved
that changes what "away from home" means.

**Rollback path:** Restrict back to localhost-only if LAN exposure
proves risky.

**Recorded by:** Claude Sonnet 5, from the 2026-10-17 session.

---

## 2026-10-20 — Phase 1 plan approved, with OB1-local bootstrap and doc refresh added

**Status:** Superseded — see the 2026-11-04 correction entry at the
end of this file. Approval never actually happened; this entry
recorded a belief at the time, not a verified fact. Kept as-is
otherwise, as the historical record of what was believed.

**Decision:** The Phase 1 plan (now `docs/phase-1-plan.md`, after the
2026-11-04 restructuring — see correction entry) is
approved. Three items added at approval: install OB1 local via
Docker (fresh install, not a repair of the crashed `ob1-local`
instance); transfer cloud OB1's thoughts to the new local OB1 using
get-thoughts/save-thoughts calls; update the architecture documents
and diagrams once that bootstrap work lands.

**Replaces:** The plan's prior draft status and its vaguer
"cloud OB1's thoughts are read once and transferred" bootstrap
wording.

**Reason and evidence:** User approval, with these three additions
given directly at approval time.

**Affected unfinished work:** Acceptance test 0 (bootstrap flow)
now also requires a running local OB1 Docker container and a
matching thought count after transfer.

**Revisit when:** The bootstrap work is implemented, or the local
instance's enhanced-mcp tool names turn out to differ materially
from get-thoughts/save-thoughts.

**Rollback path:** Revert to the prior draft wording; no canonical
data is touched by this decision alone.

**Recorded by:** Claude Sonnet 5, from the 2026-10-20 session.

---

## 2026-10-22 — TheBrain adds Note search; cro_index's job narrows

**Status:** Active

**Decision:** TheBrain's Local API now supports Note-body search
(verified live, twice against real data, once with a written-and-
deleted test note). This closes the gap that was `cro_index`'s main
reason for existing. `cro_index` is kept, but its job narrows: it no
longer needs to be the only way to find Note text. It stays
responsible for meaning-based (semantic) search and for combining
TheBrain + OB1 results in one search — jobs TheBrain's new search
still can't do (it is literal/keyword only, not semantic).

**Replaces:** The 2026-10-11 "Use a disposable local hybrid retrieval
index" decision's stated reason (Note-body search was unreliable).
That decision's conclusion (build `cro_index`) still stands; only its
justification changes.

**Reason and evidence:** Live re-test 2026-10-22 against the real
"Growth" Brain and an isolated test Brain. Found: Note search works;
~20s indexing delay; literal/keyword matching only, not semantic;
Markdown notes confirmed real and round-trip correctly.

**Affected unfinished work:** `docs/capability-matrix.md`'s Notes and
Search sections, and Phase 1 acceptance test 2's stated rationale
("closes TheBrain's Note-search gap") need updated wording — the test
itself still has value for the semantic/cross-source job.

**Revisit when:** TheBrain adds its own semantic/fuzzy search, which
would narrow `cro_index`'s remaining job further.

**Rollback path:** None needed — this only corrects a reason, not a
decision or any canonical data.

**Recorded by:** Claude Sonnet 5, from the 2026-10-22 session.

---

## 2026-10-22 — CRO never reads a repository directly; the "repository adapter" is cancelled

**Status:** Active

**Decision:** CRO has no direct filesystem or Git access to any
repository, ever. There is no CRO-side "repository adapter." A
repository's content reaches CRO only two ways, both skill-initiated
and read-only from CRO's side:

- **Pull:** a skill reads its own cards/files, pulls out a query term,
  and calls CRO's search/`recall_context`. CRO answers only from
  TheBrain/OB1/Plane/`cro_index`, never from the repo. The skill writes
  CRO's answer back into its own repo content.
- Capture (push) never comes from a skill. It only ever comes from the
  user directly, or from the scheduled public-ingest queue.

**Replaces:** Every prior description of CRO reading repositories
directly — the "Repository adapter" as a live `IContextSource`, the
Phase 1/Phase 2 "repository adapter" delivery-plan line items, and the
Phase 1 plan's framing of repo-grounded retrieval as "deferred to a
second slice." It is not deferred. It never happens inside CRO.

**Reason and evidence:** User correction, worked through with a
concrete example (a skill reading the Jennifer Rose card's "EDS" tag,
querying CRO, and writing the answer back into the card by hand) and a
second example (the `pers-research` repo being bulk-migrated into
TheBrain/OB1/`cro_index` once, then archived — a one-time migration
event, not an ongoing adapter relationship).

**Affected unfinished work:** `docs/README.md` (Sections 3.1, 5, 5.4,
7, 8, 9, 15, 16, 17, 18), ADR 0001, `docs/phase-1-plan-draft.md`,
`docs/developer-architecture-overview.md`, and 6 of 8 architecture
diagrams (`01`, `02`, `03`, `04`, `06`, `07`) all updated to match.
`docs/capability-matrix.md`'s Repository adapter section is kept but
relabeled as skill-author reference, not a CRO capability — the
verified Git/file research is still real, just aimed at a component
that no longer exists inside CRO.

**Revisit when:** A future, separately-approved project explicitly
gives CRO its own repository access — not expected under the current
design.

**Rollback path:** Reinstate the repository adapter as a new, explicit
decision if a real need appears; the relabeled capability-matrix
research would still apply.

**Recorded by:** Claude Sonnet 5, from the 2026-10-22 session.

---

## 2026-11-03 — CRO runs on the laptop, not the desktop

**Status:** Active

**Decision:** CRO (the full Docker stack) runs on the laptop only. Its
API/MCP surface is exposed both on the internal LAN and locally on the
laptop itself. No desktop-hosted CRO, no desktop-to-laptop sync path,
and no Docker-stack clone between the two machines.

**Replaces:** The earlier open question of whether the whole local
Docker stack could be cloned from desktop to laptop for travel use.

**Reason and evidence:** User directive. The point is to remove travel
friction — since CRO already lives on the laptop, nothing needs to be
synced *from* the laptop before a trip. Hosting it on the desktop
instead would recreate exactly the sync problem this decision avoids.

**Affected unfinished work:** Any future install/ops documentation,
deployment scripts, or Docker Compose setup for CRO must target the
laptop as the only host. `CURRENT.md`'s Non-negotiables, deferred/
parked list, and open questions updated to match.

**Revisit when:** A real multi-machine requirement appears (e.g. the
laptop becomes unavailable as a host) and is explicitly approved as a
new decision.

**Rollback path:** Supersede this decision explicitly before hosting
CRO anywhere else.

**Recorded by:** Claude Sonnet 5, from the 2026-11-03 session.

---

## 2026-11-04 — Correction: Phase 1 plan was never actually approved; restructured into a 5-phase roadmap

**Status:** Active

**Decision:** Two corrections, made together:

1. The 2026-10-20 "Phase 1 plan approved" entry above was wrong.
   `CURRENT.md` said "awaiting formal approval" the entire time; the
   two documents contradicted each other and were never reconciled
   until now. The plan still needs formal approval.
2. What was a single `docs/phase-1-plan-draft.md` is now
   `docs/phase-roadmap.md` (overview + cross-cutting decisions) plus
   five per-phase docs, `docs/phase-1-plan.md` through
   `docs/phase-5-plan.md`. Only Phase 1 (Bootstrap) is detailed;
   Phases 2–5 (Lookup+Plane, Create/Update, Reorg, External Gather)
   are broad-stroke only, named at the user's request to map the
   50,000-foot shape of the whole project, not just the first slice.

**Replaces:** The 2026-10-20 approval claim, and the single-document
Phase 1 plan structure.

**Reason and evidence:** User request to restructure into an overall
roadmap (with a Mermaid diagram) plus separate phase documents, so
Phase 1's readiness for prototyping is visible against the broader,
still-broad-stroke shape of Phases 2–5.

**Affected unfinished work:** `CONTEXT-MAP.md`,
`docs/developer-architecture-overview.md`, and every file path
reference to the old `docs/phase-1-plan-draft.md` updated to match.

**Revisit when:** Each of Phases 2–5 gets its own detailed planning
pass (the same live-verification treatment Phase 1 got against the
real TheBrain/OB1 APIs).

**Rollback path:** None needed — this is a correction and a doc
restructuring, not a reversible design choice.

**Recorded by:** Claude Sonnet 5, from the 2026-11-04 session.

---

## 2026-11-04 — cro_index settled as a 10-table schema on plain Postgres, not Supabase

**Status:** Active

**Decision:** `cro_index`'s real schema — `brains`, `thebrain_types`,
`sensitivity_tiers`, `thebrain_nodes`, `ob1_nodes`, `plane_workitems`,
`node_links`, `chunks`, `edges`, `sync_state` — settled through live
verification against the real TheBrain, OB1, and Plane APIs, in
`docs/cro-index-schema.md` and its canonical diagram
`docs/architecture/09-cro-index-schema.mmd`. Separately: `cro_index`
runs on **plain Postgres + pgvector, not Supabase** — only OB1 needs
the full Supabase stack (its own code depends on Supabase Edge
Functions to serve its MCP surface); `cro_index` is accessed directly
by CRO's own .NET code via Npgsql, with no second client needing
Supabase's Auth/Realtime/Storage layers.

**Replaces:** The earlier 4-table sketch (`nodes`, `chunks`, `edges`,
`sync_state`) that had been carried in `CURRENT.md` since before this
live-verification pass — that sketch assumed a single shared `nodes`
table across TheBrain and OB1, which turned out to be wrong (a
TheBrain Thought and an OB1 thought aren't 1:1). Also replaces the
generic "Local PostgreSQL/Supabase with pgvector" framing — Supabase
specifically is not used for `cro_index`.

**Reason and evidence:** Live field verification against real
TheBrain Types/brains endpoints, a real OB1 instance, and a real
Plane work item, done over the course of this session; confirmed
Supabase isn't needed by checking what `cro_index`'s actual clients
are (CRO itself only) versus OB1's (which genuinely needs Supabase
Edge Functions).

**Affected unfinished work:** Epic 0's Postgres install
(`docs/Epic 0 - Installs/Feature 02 - Dedicated Postgres with pgvector
for cro_index/`) targets plain Postgres,
not Supabase. Epic 1's bootstrap code writes to this exact schema.

**Revisit when:** A second client needing Supabase-specific features
(Auth, Realtime, Storage) for `cro_index` data is identified — not
expected under the current design.

**Rollback path:** Migrate `cro_index` to Supabase if a future need
genuinely requires it; the schema itself doesn't change, only the
hosting layer.

**Recorded by:** Claude Sonnet 5, from the 2026-11-04 session.

---

## 2026-11-04 — Local embedding model and chunk-splitting rule settled

**Status:** Superseded 2026-11-05 (model and dimension only; the
chunk-splitting order still applies, see the 2026-11-05 entry)

**Decision:** `ElBruno.LocalEmbeddings` (NuGet), default
`all-MiniLM-L6-v2` model via ONNX Runtime, 384 dimensions, in-process,
no network call — built on `Microsoft.Extensions.AI`'s
`IEmbeddingGenerator` abstraction (interfaces only, no model or
compute in the namespace itself). Kept on the CPU execution provider.
Chunk-splitting: logical blocks (Markdown headings) first, then
paragraph, then sentence if still over the ceiling; a thought/note
with no logical structure at all falls back to one chunk made from
its title alone. The real ceiling is **256 WordPiece tokens** — a
hard model limit (confirmed from the model's own documentation, not
an estimate; its tokenizer config misleadingly says 512), not a loose
character count.

**Replaces:** An earlier placeholder of "embedding model/dimension
not yet chosen."

**Reason and evidence:** Compared `ElBruno.LocalEmbeddings`,
`OnnxTextEmbeddings.NET`, and `SmartComponents.LocalEmbeddings` on
maintenance activity, model size, and licensing (web search, current
as of 2026-11-04); verified the chunk-splitting rule against a real
21,000-character TheBrain note ("Who Am I") and a real content-free
bookmark thought (the Flipboard case).

**Affected unfinished work:** Epic 1's bootstrap code must call this
model when populating `chunks`; the 256-token ceiling must be
enforced by actual tokenization, not a character-count proxy.

**Revisit when:** Search quality against real queries proves this
model insufficient — the same package's `EmbeddingGemma` variant
(768-dim) is a drop-in upgrade path already identified.

**Rollback path:** Swap the embedding generator implementation;
`chunks.embedding`'s dimension would need a migration if the
replacement isn't also 384-dim.

**Recorded by:** Claude Sonnet 5, from the 2026-11-04 session.

---

## 2026-11-04 — Sensitivity tier is content-based, never person-based

**Status:** Active

**Decision:** `sensitivity_tier` (`standard`/`personal`/`restricted`)
reflects how private the *content* is, never just whether a specific
person is named. `restricted` means actual medical/financial-grade
records (confirmed live to exist in TheBrain's Filing Cabinet brain).
Attribution — whose fact something is — is a separate, not-yet-
modeled axis from sensitivity.

**Replaces:** An earlier framing (in `CURRENT.md` and this project's
original design notes) describing sensitivity as "an attribution tag
on facts that are specifically Kittery's" — conflated two different
things. Corrected after live-checking a real TheBrain note ("Who Am
I") that names "my wife, Kittery" by name in an otherwise ordinary,
non-sensitive personal-reflection note.

**Reason and evidence:** User correction, verified against the real
note's content live.

**Affected unfinished work:** Any sensitivity-classification logic
Epic 1 builds must key off content type, not named-person detection.

**Revisit when:** Attribution modeling is designed — needed before
`restricted` can be applied correctly to Filing Cabinet content in
all cases, not just the ones confirmed so far.

**Rollback path:** None needed — this is a correction, not a
reversible design choice.

**Recorded by:** Claude Sonnet 5, from the 2026-11-04 session.

---

## 2026-11-04 — Laptop GPU and hostname decisions refined

**Status:** Active

**Decision:** Two related infrastructure decisions, both refined from
earlier same-day drafts: (1) only the Surface Book's **tablet-half**
integrated GPU is off-limits for any CRO workload — the base's
discrete GPU (GTX 1660 Ti) is allowed if explicitly pinned there,
since the user's actual prior hardware failure (a Surface Book 2
battery/display-panel heat problem while gaming on AC power) points
specifically at the tablet half, not the base; (2) CRO's permanent
hostname is a subdomain of `sol3.net` (the user's personal domain,
not the writing/business `quantumfracturecreative.com`), resolved by
a local DNS resolver (dnsmasq, in Docker, on the laptop) to every
device on the home LAN via the router's DHCP setting, with Cloudflare
`1.1.1.1` primary / Quad9 `9.9.9.9` secondary as upstream.

**Replaces:** An initial blanket "no GPU at all" rule (refined to
tablet-only once the real failure history was examined) and an
initial wrong guess that `quantumfracturecreative.com` was the right
domain (corrected to `sol3.net`).

**Reason and evidence:** User-provided hardware history and domain
ownership facts, both corrected same-day.

**Affected unfinished work:** Epic 0's DNS resolver and embedding
model installs (`docs/Epic 0 - Installs/Feature 08...md`,
`Feature 09...md`) depend on both of these.

**Revisit when:** Not expected to change absent new hardware or
domain facts.

**Rollback path:** None needed — these are corrections to same-day
drafts, not reversals of settled, long-standing decisions.

**Recorded by:** Claude Sonnet 5, from the 2026-11-04 session.

---

## 2026-11-04 — Phases renamed to Epics; old §15 delivery plan reconciled; Epic 6 added

**Status:** Active

**Decision:** Every "Phase N" renamed to "Epic — Title" (file names
unchanged, `phase-N-plan.md`, for stable history) — the user is
organizing this project's planning as Epics breaking down into
Features and eventually User Stories/PBIs, mirrored in new
`docs/Epic N - Title/` folders (Epic 0 fully broken into Feature
files). A new Epic 6 — Skill Hooks and Controlled Writes was added.
Separately: `docs/README.md` §15's older, separate 0-5 delivery plan
(written 2026-10-11, numbers collided with this Epic list) was marked
superseded, not deleted — its real content was folded into the
correct Epic (duplicate/stale detection into Epic 1; context-recall
provenance/serendipity and standing resurfacing directives into
Epic 2; nearly all of "general capture" into Epic 3; restructure
suggestions into Epic 4; the entire skill-hooks phase into the new
Epic 6).

**Replaces:** The single-phase "Phase 1 plan" framing, the 5-phase
roadmap from earlier the same day, and `docs/README.md` §15's
0-5 delivery plan as the active planning document (kept as historical
record).

**Reason and evidence:** User direction to organize planning as
Epics/Features/User-Stories, matching how the Plane project (Epic 0)
will actually hold this work (parent/child work items tagged
EPIC/FEATURE/USER STORY or PBI, since Plane has no native type field
for this). The old §15 plan was found while checking whether an
"older Phase 0" the user remembered actually existed — it did, and
its content didn't contradict anything decided since, so it was
reconciled rather than discarded.

**Affected unfinished work:** `CURRENT.md`, `CONTEXT-MAP.md`, and
every `docs/phase-N-plan.md` updated to match. Phases 2-6 (now broad-
stroke Epics) still need their own detailed, live-verified planning
pass the way Epic 0/1 got.

**Revisit when:** Each Epic's Feature breakdown is extended (only
Epic 0 has one so far) or a User Story/PBI layer is actually built
inside a Feature.

**Rollback path:** The file names never changed, so reverting the
display name back to "Phase" would just be a find-and-replace; not
expected to be needed.

**Recorded by:** Claude Sonnet 5, from the 2026-11-04 session.

---

## 2026-11-05 — OB1 can update and delete; OB1 is local-only

**Status:** Active

**Decision:** OB1 is installed in Docker on the laptop and is never
given cloud access, for anyone. Every CRO data store is inside the
trusted environment (laptop, LAN-only API/MCP).

**Replaces:** The 2026-10-22 claim that OB1 cannot delete a thought
in any build, and the reason given there for rejecting OB1 as the
fuzzy-search/sync home ("no delete tool"). That reason no longer
holds. The 2026-10-22 decision itself (keep `cro_index`) is not
reversed here.

**Reason and evidence:** User correction, verified against the
upstream repo 2026-11-05: delete-thought-mcp (hard delete),
rest-api DELETE /thought/:id, update-thought-mcp, enhanced-mcp
update_thought. Local route: recipes/local-brain-no-mcp.

**Affected unfinished work:** Epic 0 Feature 03. The REST-vs-MCP
question and the cloud-embedding question are open there. Gap 1 of
the Epic 1 review (what bootstrap writes to OB1 for restricted
nodes) is re-opened with the corrected facts.

**Revisit when:** Feature 03's trial shows rest-api cannot run
offline, or enhanced-mcp ships delete plus restore.

**Rollback path:** None needed; this corrects facts.

**Recorded by:** Claude Sonnet 5.5, from the 2026-11-05 session.

---

## 2026-11-05 — OB1-only thoughts are normal; full text to OB1; Epic 1 test 0 reworked

**Status:** Active

**Decision:** Three linked changes to the Epic 1 plan:
1. OB1 holds some business-process information that exists nowhere
   else. The invariant is now: every `thebrain_nodes` and
   `plane_workitems` row links to at least one `ob1_nodes` row (OB1
   universal coverage). An `ob1_nodes` row may have zero links.
2. Bootstrap writes every node's full text to OB1, `restricted`
   content included. OB1 is local-only inside the trusted boundary.
   `sensitivity_tier_id` gates search-time return (Epic 2), not
   storage.
3. Acceptance test 0 no longer compares thought counts between
   sources. It checks `cro_index` rows and links directly. The
   cloud-to-local OB1 transfer is deferred.

**Replaces:** The `node_links` rule "an OB1 entry never stands alone"
in `docs/cro-index-schema.md`; the Epic 1 test 0 clause "thought
count in local OB1 matches the cloud source"; the 2026-11-05 gap 1
question of a pointer-only exception for `restricted` nodes.

**Reason and evidence:** User direction in the 2026-11-05 Epic 1
review. The schema itself says OB1 and TheBrain are not 1:1, so the
old invariant and the count test contradicted it.

**Affected unfinished work:** `docs/phase-1-plan.md` and
`docs/cro-index-schema.md` (both updated 2026-11-05). Bootstrap code
must write links in the direction above and must not flag OB1-only
rows as errors.

**Revisit when:** The cloud OB1 transfer is brought back in scope,
or an OB1-only row proves to need a link after all.

**Rollback path:** Restore the earlier invariant text and test 0
clause from git history; no canonical data is affected.

**Note:** The 2026-11-04 schema entry's "10-table" count predates
`node_flags`, which was added later that same day (Epic 1
orphan/stale/hub design). `cro_index` now has 11 tables. That entry
is left as written, since it records what was true when it was made.

**Recorded by:** Claude Sonnet 5.5, from the 2026-11-05 session.

---

## 2026-11-05 — CRO application shape: modular monolith, vertical slices

**Status:** Active

**Decision:** One deployable ASP.NET Core minimal-API app, project and
namespace `CRO` (`src/CRO.slnx`, `src/CRO/CRO.csproj`). Code is grouped
by capability then use case. REST endpoints and MCP tools are adapters
over the same handlers. No mediator package; typed handlers are
injected directly. Event sourcing only for a named workflow that
justifies it.

**Replaces:** The roadmap's open choice of a mediator package per
slice.

**Reason and evidence:** Developer discussion 2026-11-05, recorded in
`docs/developer-before-you-code.md` (intended design, not
implemented). The user approved the `src/CRO` scaffold.

**Affected unfinished work:** Every slice's structure; identity
provider, token issuance and module boundaries remain undecided.

**Revisit when:** A concrete need justifies a mediator package or
event sourcing.

**Rollback path:** The scaffold is one endpoint; restructure freely.

**Recorded by:** Claude Sonnet 5.5, from the 2026-11-05 session.

---

## 2026-11-05 — Epic 1 (Bootstrap) approved, 7 Feature files

**Status:** Active

**Decision:** Epic 1 is approved as planned in `docs/phase-1-plan.md`.
Broken into 7 Feature files under `docs/Epic 1 - Bootstrap/`:
Lookup-Table Resync, Bootstrap Data Flow, Duplicate Detection,
Orphan/Stale/Hub Flagging, Post-Bootstrap Vector Pass (deferred —
catch-all hub + duplicate-neighborhood expansion, re-run against the
populated `cro_index` rather than run once at bootstrap time), and two
found live during this same review: Private-Content Detection and
Misplaced-Private Flagging, and Note-Embedded Cross-Brain Link
Detection.

Settled through live verification against the real Growth brain:

- **Orphan** = zero `node_links`/`edges` rows, either side.
- **Stale** = per-Type `thebrain_types.staleness_threshold_days`,
  blank by default (opt-in, prevents a first-run flood on a years-old
  brain); Software set to 180 days, Medical/Financial left blank.
- **Hub (simple)** = 30+ links on a non-Type node; Type Thoughts
  (`kind=2`, e.g. "Rolodex," 100+ children) always excluded.
- **Catch-all hub / duplicate-neighborhood expansion** = embedding-
  based, deferred until real `cro_index` embeddings exist to tune a
  similarity cutoff against.
- **Misplaced-private** = TheBrain's undocumented `acType` field
  (`thebrain_nodes.access_type`), confirmed live as a real but
  unreliable "Private" marker (inconsistently applied even by the
  user, e.g. "Surgeries" marked Private next to unmarked, clearly-
  medical siblings). An input signal to `sensitivity_tier_id`, never a
  blind copy. Flags a Private node outside the one `brains` row marked
  `is_private_home` (Filing Cabinet).
- **Note-embedded cross-brain links** = confirmed live that TheBrain's
  `brain://` URIs live inside Note Markdown bodies, not in the
  `/graph` response at all — need their own scan, separate from the
  `edges` walk.

**Replaces:** The earlier "orphan/stale/hub not yet designed" gap and
the "TheBrain has no native sensitivity field" claim in
`docs/cro-index-schema.md` (both corrected here).

**Reason and evidence:** All of the above verified live against the
real Growth and Filing Cabinet brains during this session — real
examples named and checked, not invented ("Rolodex," "Timeline,"
"Quiver Software Development," "Technologist & ASPInsider," "Val
Docs," "Health Records").

**Affected unfinished work:** `docs/cro-index-schema.md` (new
`brains.is_private_home`, `thebrain_nodes.access_type`, `node_flags`
table, `node_links.detection_method`/`similarity_score` columns),
`docs/phase-1-plan.md` (Features, schema-touched, acceptance tests),
`docs/Epic 1 - Bootstrap/` (Features 01-07), `CURRENT.md`,
`CONTEXT-MAP.md`. Epic 0's installs (`docs/phase-0-plan.md`) are next,
then Epic 1's actual code.

**Revisit when:** The deferred Feature 05 vector-pass similarity
cutoffs are set (needs real post-bootstrap embeddings); or Epic 1's
code surfaces a real case none of these rules predicted.

**Rollback path:** Approval can be revoked and the plan sent back with
requested changes; nothing downstream (code) exists yet to unwind.

**Recorded by:** Claude Sonnet 5, from the 2026-11-05 session.

---

## 2026-11-05 — cro_index embeddings switch to nomic-embed-text (768)

**Status:** Active

**Decision:** `cro_index` embeds with `nomic-embed-text` (768
dimensions), served by the local Ollama container from Epic 0 Feature
03 over HTTP, CPU only. `chunks.embedding` is `vector(768)`, applied
by migration `V004__chunks_embedding_768.sql`. CRO no longer embeds
in-process with `ElBruno.LocalEmbeddings`.

**Replaces:** the 2026-11-04 model choice (`all-MiniLM-L6-v2`, 384
dimensions, in-process). The chunk-splitting order (headings, then
paragraph, then sentence, then title-only) still applies.

**Reason and evidence:** the user wanted the larger model if it ran
fast enough. Measured 2026-11-05 on this laptop's CPU through Ollama:
about 0.05 s for a short text, about 0.38 s for about 1000 characters,
1.7 to 2.1 s for about 4000 characters (Epic 0 Feature 03, User Story
06). One model also serves OB1 and CRO. The table was empty, so the
change was one `ALTER TABLE`. Verified: a 768-dimension insert and
similarity query work and a 384-dimension insert is rejected.

**Affected unfinished work:** Epic 1's bootstrap code must call Ollama
over HTTP, so CRO depends on that container being up to embed. The
256-WordPiece-token ceiling belonged to MiniLM and no longer applies
as written; the new model's real token limit, its tokenizer, and
whether it needs the text prefixes its model card describes are not
yet verified. Keep the conservative chunk target (about 1000
characters) until they are.

**Revisit when:** search quality against real queries is poor, the
model degrades, or timing becomes a problem (Epic 0 Feature 03, User
Story 12 records this).

**Rollback path:** a new migration back to the old dimension (the
table must be empty or re-embedded), and an in-process generator.

**Recorded by:** Claude Sonnet 5.5, from the 2026-11-05 session.

---

## 2026-11-06 — Ports 80 and 443 are reserved; CRO services use high localhost ports

**Status:** Active

**Decision:** No CRO setup may publish host ports 80 or 443. They are
reserved for future projects. Every CRO service publishes on
`127.0.0.1` at a higher port: OB1 gateway 8000, Plane 8090,
`cro_index` Postgres 5433.

**Replaces:** nothing. Plane's upstream compose publishes 80 and 443 on
every interface; Epic 0 Feature 04 changed that.

**Reason and evidence:** the user's rule, 2026-11-06. Feature 08 (local
DNS) may later want a friendly name, which can be done with a proxy on
80 or 443 in front of these services without moving them.

**Affected unfinished work:** every future `src\Infra\NN-name` setup
must override its ports the same way. Check the compose file for 80 or
443 before first start.

**Revisit when:** a future project needs a different port plan.

**Rollback path:** change the `ports` lines in the affected compose
files.

**Recorded by:** Claude Sonnet 5.5, from the 2026-11-06 session.

---

## 2026-11-06 — Keep postgres-cro, remove pgvector-cro

**Status:** Active

**Decision:** `postgres-cro` (writenotenow/postgres-mcp v3.1.0,
`--tool-filter codemode`) is the one MCP server for `cro_index`.
`pgvector-cro` (mcp-server-pgvector 0.1.0) is removed: its `.mcp.json`
entry and `src\Infra\pgvector-mcp.cmd`.

**Replaces:** the Epic 0 Feature 07 plan to trial both and keep one
(2026-11-04).

**Reason and evidence:** Both passed the 10 baseline tests on
2026-11-06 (`docs/Epic 0 - Installs/Feature 07 - cro_index Postgres
MCP Connection/Baseline MCP Tests.md`). `postgres-cro` covers schema,
insert, vector query, delete and the vector helpers in one server and
can build a vector inside the database. `pgvector-cro` has no delete
tool, needs the 768-number vector passed in as a literal list, is a
single-release unvetted package, and needed a pin to `mcp<2` to start.
Chosen by Keith.

**Affected unfinished work:** Tests 2-5 and 7-9 in the baseline are
history; tests 1, 6 and 10 are the live baseline. Epic 1's C# client
passes vectors in code, so the literal-list limit does not carry over.
Story 06 (read-only role) still applies to `postgres-cro`.

**Revisit when:** `postgres-cro`'s codemode filter or its single
`pg_execute_code` tool stops being enough, or a CRO need appears that
only a pgvector-specific tool covers.

**Rollback path:** restore `src\Infra\pgvector-mcp.cmd` and the
`pgvector-cro` entry in `.mcp.json` from commit `2194973`, then restart
Claude Code.

**Recorded by:** Claude Sonnet 5.5, from the 2026-11-06 session.

---

## 2026-11-06 — Local name through a fixed IP and a hosts file, no DNS resolver

**Status:** Active

**Decision:** `cro.home.sol3.net` is reached through a static laptop
address (`192.168.9.250`, outside the router's DHCP range) and a
hosts-file line on each desktop. There is no dnsmasq container and no
change to the router's DNS.

**Replaces:** the 2026-11-04 plan for a dnsmasq resolver in Docker,
pushed to every device through the router's DHCP DNS setting.

**Reason and evidence:** Checked 2026-11-06. Windows Internet
Connection Sharing holds port 53 on the laptop. The Gryphon router
and mesh can be changed only through the mobile app. A router DNS
change reaches every device in the house, and with the laptop off or
away devices either lose DNS or skip the local name. Only one or two
desktops need the name. Tested: the laptop keeps `192.168.9.250/24`
with working internet, and from the desktop `ping 192.168.9.250` and
`ping cro.home.sol3.net` both answer. Chosen by Keith.

**Affected unfinished work:** Feature 08 Stories 02, 04, 05, 06 and 07
are not needed. Feature 09 is unchanged (`cro.localhost` while
traveling). Phones and tablets use the address directly until a public
record or a resolver is added. No service listens on the LAN yet.

**Revisit when:** more than a few devices need the name, a phone or
tablet needs it by name, or the laptop moves to Ethernet.

**Rollback path:** delete the hosts line on each desktop, and set the
laptop's Wi-Fi network back to automatic (DHCP).

**Recorded by:** Claude Sonnet 5.5, from the 2026-11-06 session.

---

## 2026-11-06 — CRO is one address with paths; travel name is cro.localhost

**Status:** Active

**Decision:** CRO is one root address. The app routes by path (`/api`,
`/mcp`, `/admin`), not by subdomain. The name while traveling is
`cro.localhost`. No public wildcard DNS record is published.

**Replaces:** the 2026-11-04 plan in Epic 0 Feature 09 to test two
naming options, including a public `*.home.sol3.net` record pointing at
`127.0.0.1`, and keep one.

**Reason and evidence:** Keith's rule, 2026-11-06: the app handles its
own paths, so one address needs no subdomains and runs the same in
Visual Studio and on a server. Kestrel does not route by hostname. A
single name needs no wildcard record, and publishing a DNS record is
outward-facing. `cro.localhost` needs no DNS: curl resolved it to
`127.0.0.1` on 2026-11-06 (HTTP 200 from Plane). Windows itself and
`ping` do not resolve it; browsers and curl do. Details are in
`docs/Notes and Findings.md`, 2026-11-06.

**Affected unfinished work:** Feature 09 Story 02 is not needed.
Stories 03 and 04 stay Later. Epic 1 needs a Feature for publishing
the CRO app (port, listening, firewall); listening is set per app when
it is published.

**Revisit when:** a phone or tablet needs a name, you want one name to
work both at home and away, or `cro.localhost` fails in a browser on a
foreign network.

**Rollback path:** none needed; nothing was published. To reverse,
reopen Story 02 and publish the record in the sol3.net Azure DNS zone.

**Recorded by:** Claude Sonnet 5.5, from the 2026-11-06 session.
