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
