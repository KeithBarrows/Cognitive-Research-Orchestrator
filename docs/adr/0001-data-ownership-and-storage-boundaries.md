# ADR 0001: Data Ownership and Storage Boundaries

- **Status:** Accepted
- **Date:** 2026-10-11
- **Decision owners:** Keith Barrows and CRO design collaborators

## Context

The original CRO design used three external knowledge systems: Karakeep for sources, TheBrain for associations, and OB1 for durable context. That model duplicated capabilities and risked turning CRO's own database into another knowledge store.

TheBrain can hold durable source material through Thoughts, Notes, URLs, attachments, tags, and graph relationships. Project repositories already hold project-specific work and canon. OB1 provides semantic retrieval over the user's thought stream.

## Decision

Karakeep is removed from the CRO architecture.

Canonical ownership is:

| Owner | Canonical responsibility |
|---|---|
| Project repositories | Approved project work, canon, decisions, skills, runbooks, and deliberately local research |
| TheBrain | Durable knowledge, original source evidence, Notes, attachments, people, organizations, concepts, and meaningful graph relationships |
| OB1 / Open Brain | Ideas, observations, tasks, references, person notes, and other semantic breadcrumbs not yet promoted into durable structure or project canon |
| CRO | Orchestration behavior, transient scheduling/runtime state, bounded audit history, and rebuildable technical caches |

CRO must never become a user-knowledge store. Its durable state may include:

- Job checkpoints and bounded retry state
- Health and scheduling state
- Idempotency records
- File hashes, canonical identifiers, derived text chunks, embeddings, Git commit identifiers, and similar rebuildable indexes
- A bounded operational audit log

CRO must not be the canonical owner of summaries, user conclusions, source relationships, reading behavior, project decisions, or creative ideas.

The derived index is disposable infrastructure, not a third knowledge store. It finds candidates and preserves their canonical identifiers; CRO fetches live authoritative content from TheBrain or project repositories before final use. The preferred implementation direction is local PostgreSQL/Supabase with `pgvector`, using CRO-owned schemas or databases that are separate from OB1-owned storage.

## Capture policy

High-confidence source capture may automatically reuse or create TheBrain Thoughts. CRO asks the user only when placement, identity, or relationship ambiguity is material.

`Incomplete` is the human-visible tag for a capture that preserved intent but still lacks an important enrichment step. Normal completion is represented by the absence of `Incomplete`; there is no `Complete` tag.

Source volatility is computed by default. It is persisted in TheBrain only when the value is useful to the user.

## Retrieval and feedback policy

- Resolve current project and artifact from the repository, active skill, and supplied artifact or path; ask only when materially ambiguous.
- Follow explicit repository references before inferred relationships.
- Limit serendipity retrieval to one or two secondary items.
- Store durable reading or resurfacing feedback in OB1 when it represents user behavior or thought.
- Keep only transient scheduling and runtime state in CRO.

## Skill integration policy

Skills declare CRO context requirements in a standard declarative block inside the skill file. The block identifies the current artifact, explicit reference classes, desired external context, and post-skill persistence candidates.

The exact schema remains a technical-design task, but the location and declarative approach are decided.

## Consequences

- TheBrain becomes both the durable evidence store and the meaningful associative graph.
- Repository access becomes a first-class adapter and retrieval source.
- OB1 is treated as a semantic inbox and thinking history rather than a raw document archive.
- CRO data models must distinguish operational state from user knowledge.
- TheBrain Note bodies require explicit reads and derived indexing because Local API search is not reliable for Note content.
- Sensitive source text, chunks, and embeddings remain inside the trusted home environment.
- A future public capture service may provide only an untrusted inbound queue; it receives no trusted retrieval path into CRO or local knowledge systems.
- Existing Karakeep-specific documents, diagrams, flows, and tool names are superseded.
- TheBrain Local API capabilities must be verified before implementation relies on desktop features.
