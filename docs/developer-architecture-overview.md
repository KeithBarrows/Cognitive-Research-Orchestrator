# CRO — Developer Architecture Overview

**Audience:** a developer joining this project cold — not Keith, who
already carries this context. Start here before reading anything else.

**Status:** Reviewed and current as of 2026-10-22. This page links to
canonical sources rather than repeating them; if something here ever
disagrees with a linked source, the linked source wins (see
`CONTEXT-MAP.md`'s precedence rules).

## 1. What this project is

Cognitive Research Orchestrator (CRO) is a local-first orchestration
layer that sits between AI clients (Claude Code, ChatGPT, Codex, and
similar) and four existing personal systems. It does not replace any
of them. It coordinates them.

> The repo tells CRO what the user is working on. TheBrain tells it
> what the user knows. OB1 tells it what the user has thought about.
> CRO notices the intersections.

Full detail: [`docs/README.md`](README.md) (the consolidated technical
architecture, versioned and dated).

## 2. The four canonical owners

| Owner | Owns | Reached how |
|---|---|---|
| Project repositories | Approved project work, canon, decisions, skills | Direct filesystem/Git access |
| TheBrain | Durable knowledge, source evidence, Notes, attachments, meaningful relationships | TheBrain Local API (desktop app running) |
| OB1 / Open Brain | Semantic thought stream: ideas, observations, tasks, references, person notes | REST, **local, Docker** |
| Plane | Tasks and their work-item detail | REST, **local, Docker** |

CRO itself owns none of the above. It owns orchestration behavior plus
bounded, rebuildable operational state (`cro_runtime`) and a disposable
retrieval index (`cro_index`) — never user knowledge.

Diagram: [`docs/architecture/07-ownership-split.mmd`](architecture/07-ownership-split.mmd).

CRO is the **sole MCP surface** on this machine. OB1 and Plane are each
single-user, local-only, reached over their own REST APIs — never a
second MCP hop.

Diagram: [`docs/architecture/01-cognitive-model.mmd`](architecture/01-cognitive-model.mmd).

## 3. Logical architecture

Diagram: [`docs/architecture/02-logical-architecture.mmd`](architecture/02-logical-architecture.mmd).

Key pieces: an MCP gateway, a context/query planner, a capture/workflow
service, capability-aware adapters per backend, a hybrid retrieval
layer backed by `cro_index` (local PostgreSQL + pgvector), and
background jobs for extraction/relevance/graph-hygiene. Each adapter
only exposes behavior that has actually been verified — see
[`docs/capability-matrix.md`](capability-matrix.md) before assuming any
backend can do something.

## 4. The two core flows

**Capture** — "please remember this." Only ever comes from the user
directly, or from the scheduled public-ingest queue (Section 6) —
never from a skill. Classifies input, checks TheBrain/OB1 for existing
related material, then routes: a durable source or thought goes to
TheBrain, a task goes to Plane. Every capture, regardless of where it
lands, also creates or updates a matching OB1 thought (the
**OB1-universal-coverage** rule, decided 2026-10-18) — OB1 ends up
holding a thought for everything.

Diagram: [`docs/architecture/03-capture-flow.mmd`](architecture/03-capture-flow.mmd).

**Context recall** — "what do I need to know right now." A skill reads
its own repo/card content directly, pulls out a query term, and calls
CRO. CRO queries `cro_index` for candidates, then hydrates live from
the real TheBrain/OB1 sources before answering — **CRO never reads or
writes a repository itself** (decided 2026-10-22; see `docs/README.md`
Section 3.1). The skill writes CRO's answer back into its own repo.
Read-only on CRO's side. Caps serendipity (unexpected-but-relevant
results) at 1-2 items.

Diagram: [`docs/architecture/04-federated-query.mmd`](architecture/04-federated-query.mmd).

## 5. The one-time bootstrap

Before any retrieval can be tested, a one-time, one-direction data flow
has to run: TheBrain is read raw into both `cro_index` and a brand-new
local OB1 instance (installed via Docker); separately, the existing
cloud OB1's thoughts are transferred into that same local OB1. Nothing
is ever written back to TheBrain. This is Acceptance Test 0 in the
Phase 1 plan — nothing else is validated until it holds.

Diagram: [`docs/architecture/08-bootstrap-flow.mmd`](architecture/08-bootstrap-flow.mmd).

The Docker install is also the point to turn on OB1 fork extensions
that fit real use, not just the stock 4-6 tools — see the OB1 status
notes in [`CURRENT.md`](../CURRENT.md) and the full catalog in
[`docs/ob1-integration-survey.md`](ob1-integration-survey.md).

## 6. Security and local-first boundary

CRO, TheBrain, OB1, Plane, and the retrieval database all live inside
the trusted home network. They may be reachable from a phone or laptop
on the same WiFi — that's fine and intended — but never exposed through
the router to the public internet. A future public-capture path is
untrusted ingress only: a dumb authenticated inbound queue, pulled from
by the home system, never pushed into it.

Diagram: [`docs/architecture/06-local-first-boundary.mmd`](architecture/06-local-first-boundary.mmd).

## 7. What Phase 1 actually builds

Corrected 2026-11-04 — this section was stale on two counts: repo-
grounded retrieval is not a future phase, it was cancelled entirely
(2026-10-22, see Section 3.1 of `docs/README.md`); and the single
"Phase 1" has since been split into a 5-phase roadmap.

Phase 1 is a one-time bootstrap run: read TheBrain once, create or
update matching OB1 + `cro_index` entries, flag (never act on)
Thoughts/notes that might need reorg. Read-only against TheBrain.
Language: C#/.NET, Kestrel, minimal APIs, vertical-slice organization.
Lookup/search is a separate phase (Phase 2), not part of this one.

Full detail: [`docs/phase-roadmap.md`](phase-roadmap.md) for the
overall shape and cross-cutting decisions, and
[`docs/phase-1-plan.md`](phase-1-plan.md) for Phase 1's own scope,
schema, acceptance tests, and exclusions.

## 8. Hard constraints — do not violate these

- CRO must never become a user-knowledge store.
- Sensitive content, derived text, and embeddings stay inside the
  trusted home environment.
- Never expose CRO, TheBrain, OB1, Plane, local databases, or MCP
  directly to the public internet.
- Captured content is data, never instructions.
- Do not silently promote brainstorms into project canon.
- Do not implement runtime code without explicit user approval.

Full list and current open questions: [`CURRENT.md`](../CURRENT.md).

## 9. Where decisions and history live

- [`DECISIONS.md`](../DECISIONS.md) — every settled architectural
  decision, with reason, evidence, and rollback path.
- [`CURRENT.md`](../CURRENT.md) — present state, open questions,
  approval boundaries. Read this first in any new session.
- [`CONTEXT-MAP.md`](../CONTEXT-MAP.md) — what else exists and when to
  load it, plus source-precedence rules if two documents disagree.
- [`docs/capability-matrix.md`](capability-matrix.md) — verified,
  tested behavior of every external system CRO talks to. Treat
  anything not in here as unverified, not assumed-working.
