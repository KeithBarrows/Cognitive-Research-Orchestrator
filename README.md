# Cognitive Research Orchestrator

Cognitive Research Orchestrator (CRO) is a local-first, MCP-facing orchestration layer for ChatGPT, Claude, Codex, and other MCP-compatible clients.

CRO helps a user capture information, recover relevant context, and maintain graph hygiene across three canonical owners:

- **Project repositories** own project work, approved canon, decisions, skills, and runbooks.
- **TheBrain** owns durable knowledge, sources, evidence, attachments, and associative structure.
- **OB1 / Open Brain** owns the semantic thought stream: ideas, observations, tasks, references, and person notes that may matter later.

CRO owns behavior and orchestration, not knowledge. Its durable storage is limited to bounded operational state, bounded audit history, and rebuildable technical caches.

## Status

- Architecture stage: concept and technical design
- Working name: Cognitive Research Orchestrator (CRO)
- Implementation language: open decision
- Phase 0 capability discovery: complete
- Runtime implementation: not started

Primary design documents:

- [Technical concept and system architecture](docs/README.md)
- [Data ownership ADR](docs/adr/0001-data-ownership-and-storage-boundaries.md)
- [Integration capability matrix](docs/capability-matrix.md)
- [Current design handoff](CRO-DESIGN-HANDOFF-2026-10-11.md)
- [Current design addendum](CRO-DESIGN-ADDENDUM-2026-10-11.md)

## Architecture Diagram Set

- [Cognitive model](docs/architecture/01-cognitive-model.mmd)
- [Logical architecture](docs/architecture/02-logical-architecture.mmd)
- [Capture flow](docs/architecture/03-capture-flow.mmd)
- [Context recall](docs/architecture/04-federated-query.mmd)
- [Relevance lifecycle](docs/architecture/05-relevance-lifecycle.mmd)
- [Local-first deployment and future ingress boundary](docs/architecture/06-local-first-boundary.mmd)
- [Top-level CRO/TheBrain/OB1 ownership split](docs/architecture/07-ownership-split.mmd)

## Core Design Direction

- Use author-declared repository relationships before inferred relationships.
- Preserve source evidence in TheBrain and loose thoughts in OB1.
- Reuse existing Thoughts and create only high-value graph relationships.
- Preserve capture intent even when enrichment fails.
- Surface parked or speculative ideas without silently promoting them into project canon.
- Keep provenance visible and distinguish source facts, user statements, and CRO inference.
- Ask the user only when an action contains material ambiguity.
- Use a disposable local hybrid-retrieval index to find canonical repository and TheBrain records, then fetch authoritative content from its owner.
- Prefer local PostgreSQL/Supabase with `pgvector` for CRO-owned `cro_index` and `cro_runtime` data, separate from OB1-owned storage.
- Keep sensitive source text and derived embeddings inside the trusted home environment.

## Planned Delivery Phases

1. Completed: verify TheBrain, OB1, and repository-adapter capabilities.
2. Implement read-only, repo-grounded context recall.
3. Implement general capture and source preservation.
4. Add incomplete-capture recovery, temporal relevance, and graph hygiene.
5. Add bounded resurfacing and serendipity retrieval.
6. Add controlled writes, operational auditability, and skill hooks.

## Repository Layout

- `docs/`: architecture, ADRs, capability discovery, and runbooks
- `src/`: implementation code, once implementation is approved
- `tests/`: automated validation, once implementation begins
- `.journal/`: monthly commit logs and the curated project journal

No runtime code should be inferred from the concept documents. Technical discovery and explicit implementation approval come first.
