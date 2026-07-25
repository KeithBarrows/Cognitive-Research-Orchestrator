# Full Brain And Mcp

Cognitive Research Orchestrator (CRO) concept repository.

This repository defines a local-first MCP orchestration model that coordinates:

- OB1 for durable personal context and conclusions
	*Public Open Brain/OB1 references describe a shared, persistent MCP memory layer with semantic/vector retrieval and explicit thought capture so multiple AI clients can read and write the same long-term context.*
	[OB1 Open Brain Repository](https://github.com/NateBJones-Projects/OB1)
- TheBrain for associative structure and relationship mapping
	*TheBrain 15 provides local API and automation support for creating, linking, and querying thought data with real-time desktop feedback, plus high-speed local execution when the app is running.*
	[TheBrain](https://thebrain.com/products/thebrain/thebrain15)
    [TheBrain Local API](https://thebrain.com/blog/thebrain-api-local)
- Karakeep for archived external sources and evidence
	*Karakeep is an open-source, self-hostable "bookmark everything" platform with REST API/webhooks, full-text search, AI tagging/summarization, OCR, highlights, and archival features to reduce link rot.*
	[Karakeep Documentation](https://docs.karakeep.app/)

The objective is to improve retrieval, relevance, provenance, and resurfacing across large personal research collections without collapsing the three systems into a single duplicated knowledge base.

## Status

- Architecture stage: concept and technical design
- Working name: Cognitive Research Orchestrator (CRO)
- Implementation language: open decision

Primary architecture and design document:

- docs/README.md

## Architecture Diagram Set

- docs/architecture/01-cognitive-model.mmd
- docs/architecture/02-logical-architecture.mmd
- docs/architecture/03-capture-flow.mmd
- docs/architecture/04-federated-query.mmd
- docs/architecture/05-relevance-lifecycle.mmd

## Core Design Direction

- Keep canonical ownership separate by system
- Link across systems rather than duplicate source content
- Preserve provenance for every surfaced result
- Age and demote stale implementation guidance instead of deleting it
- Require explicit approval for high-impact cross-system writes

## Planned Delivery Phases

1. Technical discovery and capability matrix
2. Read-only federated retrieval
3. Capture enrichment pipeline
4. Temporal relevance and supersession handling
5. Resurfacing and reading-queue behavior
6. Controlled cross-system writes with auditability

## Repository Layout

- docs/: architecture, ADRs, and runbooks
- src/: implementation code (to be created as decisions are finalized)
- tests/: automated validation (to be created with implementation)
- journal/: session continuity and operating notes

## Notes

- This repository currently captures architecture, policy, and flow design.
- Project scaffolding for a concrete .NET build should follow approved manifest-first instructions before any file generation.
