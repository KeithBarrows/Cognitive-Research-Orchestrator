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
