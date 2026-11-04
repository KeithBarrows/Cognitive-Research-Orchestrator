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

**Status:** Active

**Decision:** The Phase 1 plan (`docs/phase-1-plan-draft.md`) is
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
