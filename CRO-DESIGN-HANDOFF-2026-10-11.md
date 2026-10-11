# Cognitive Research Orchestrator (CRO) — Design Handoff

**Date:** 2026-10-11  
**Purpose:** Give Codex CLI enough context to continue the CRO design from the current discussion without re-deriving the architecture.

## 1. Current Goal

CRO should become an **MCP-facing orchestration layer** that can be used from ChatGPT, Claude, Codex, and other MCP-compatible clients.

The user should be able to make simple requests such as:

- “Save this URL.”
- “Save these files.”
- “Remember this idea.”
- “I had an idea for *The Fractured Horizon* but do not have time to work it in now.”
- “What parked ideas might matter to this chapter?”
- “I’m working on this character/worldbuilding/plot card — surface anything relevant I may have forgotten.”

CRO should do the hard work of deciding where information belongs and what existing material may be relevant, while keeping the user closely involved in creative decisions.

## 2. Non-Negotiable Architecture

CRO is **not** a durable knowledge store.

There are only two persistent knowledge/memory stores:

1. **TheBrain**
2. **OB1 / Open Brain**

Project repositories remain the canonical source for project work/canon.

Conceptually:

```text
ChatGPT / Claude / Codex / other clients
                |
               MCP
                |
                v
               CRO
        orchestration/executive layer
          /        |        \
         /         |         \
        v          v          v
   Project Repos  TheBrain    OB1
   project truth  durable     semantic
                  knowledge   thoughts
```

CRO may eventually use **rebuildable technical caches** for performance (file hashes, embeddings, Git commit IDs, etc.), but those are infrastructure only. They must never become a third source of truth.

**Core principle:**  
> CRO owns behavior and orchestration, not knowledge.

## 3. Ownership by System

### Project repositories

Repositories own project-specific canonical work such as:

- character cards
- worldbuilding cards
- series / act / book / chapter / scene plot artifacts
- manuscript chapters
- canon
- project decisions
- skills and runbooks
- project-local research where deliberately kept there

CRO should read repo material when relevant but should not duplicate it into TheBrain or OB1 merely for convenience.

### TheBrain

TheBrain is the durable associative knowledge and evidence store.

It should hold:

- sources
- documents
- URLs
- attachments
- transcripts
- research
- people
- organizations
- technologies
- historical material
- concepts
- long-term notes
- relationships between durable concepts
- provenance/evidence

TheBrain is a true graph (“The Plex”), not a folder tree.

Thoughts can have:

- parents
- children
- sideways/jump relationships
- multiple parents/contexts
- Thought Types
- Tags
- Notes
- Attachments
- Link Types
- native created/modified timestamps
- Calendar/Timeline Events

### OB1 / Open Brain

OB1 is best treated as a **semantic inbox / thinking history**.

Its currently exposed thought categories include:

- `observation`
- `task`
- `idea`
- `reference`
- `person_note`

OB1 is useful for:

- loose ideas
- observations
- tasks
- references
- brainstorming
- things not yet promoted into canon
- things that may matter later but do not yet deserve durable graph structure
- semantic rediscovery across unrelated interests

OB1 should **not** be the raw archive for PDFs, transcripts, or full research sources.

A useful distinction:

> If forgetting something would lose knowledge/evidence, TheBrain is the likely home.  
> If forgetting something would lose a thought, idea, observation, task, or useful semantic breadcrumb, OB1 is the likely home.

## 4. TheBrain Modeling Rules

TheBrain already provides multiple ways to represent information. CRO should use the **cheapest useful representation**.

### Thought

A durable thing worth independently navigating/retrieving.

Examples:

- a person
- a project
- a technology
- an organization
- a source
- a historical event
- a durable concept

### Thought Type

Answers:

> “What is this?”

Potential controlled vocabulary (keep small):

- Person
- Organization
- Project
- Software
- Technology
- Concept
- Event
- Place
- Source
- Document
- Book
- Task
- Decision
- Topic

Do not proliferate Types unnecessarily.

### Tags

Answers:

> “What characteristics/state does this have?”

Examples:

- Incomplete
- Complete
- Needs Review
- Stale
- Superseded
- Personal
- Work
- YouTube
- Historical

Tags are cheap facets/state. They are preferable to creating extra graph nodes for status bookkeeping.

### Plex links

Plex links are expensive and should be meaningful.

Use them when traversing the relationship later would add value.

The Plex can represent:

- parent/child
- multiple parents
- sideways/jump relationships
- cross-domain relationships
- historical associations
- subject associations

**Important:** Multiple-parent and lateral relationships are normal and expected.

### Link Types

Link Types add meaning to relationships.

Examples:

- `released by`
- `served in`
- `alternative to`
- `source for`
- `discusses`
- `part of`
- `inspired by`

CRO should treat an edge as richer than a simple connection:

```text
from Thought
to Thought
Plex relation: parent / child / jump
Link Type: semantic meaning of relationship
direction
```

Investigate current Local API support for reading/writing Link Types before relying on automation.

### Notes

Notes can contain rich text/Markdown, URLs, bullet points, checkboxes, etc.

Use Notes for:

- compact summaries
- extracted concepts
- provenance
- CRO annotations
- historical context
- key claims
- source metadata
- concise research synthesis

Do **not** dump full large source documents into Notes by default.

Rule:

> Notes are the synthesized knowledge representation; attachments are the lossless source representation.

### Attachments

Use attachments for original evidence:

- PDF
- DOCX
- Markdown
- transcript
- VTT
- HTML snapshot
- image
- source file
- screenshots where layout matters

TheBrain stores attachments under the hood on the local filesystem; CRO should access/manage them through TheBrain/API where possible rather than manipulating TheBrain’s internal UUID file structure directly.

### Timeline / Calendar Events

TheBrain’s bottom Timeline is a classic event/calendar facility.

It does **not** infer dates from Plex relationships such as `Boot Camp -> April -> 1984`.

A Calendar Event has:

- start/end
- duration
- all-day
- reminder
- recurrence
- location
- description
- optional Associated Thought

Use Calendar Events for actual occurrences worth calendaring, not every historical date mentioned in a source.

### Native timestamps

TheBrain Thoughts appear to have native timestamps/modification history.

Do not invent duplicate “captured” metadata unless needed.

Distinguish these time concepts:

1. Thought created/modified time
2. Source publication date
3. Historical/subject date
4. Calendar Event date
5. Last externally verified date (CRO-maintained only when useful)

## 5. Temporal / Historical Handling

The user frequently captures historical material.

Do not confuse:

- when a source was published
- when the subject happened
- when the Thought was added to TheBrain

Example:

A 2026 article about an event in 1984:

```text
Thought timestamp: 2026
Source publication: 2026
Subject/event: 1984
```

The user already has reusable Month Thoughts (12 canonical month Thoughts) and Year/Timeline structures in TheBrain.

Do **not** automatically convert these to Tags.

Month/Year Thoughts may remain useful human navigation anchors even if CRO also stores or infers machine-readable temporal metadata.

Temporal graph links are optional navigation conveniences, not necessarily the authoritative date store.

## 6. Capture Must Be General, Not URL-Specific

CRO needs one general ingestion concept.

Inputs may include:

- URL
- PDF
- DOCX
- Markdown
- pasted text
- image
- ZIP/archive
- YouTube transcript
- subtitle/VTT file
- a user idea with no source yet
- multiple heterogeneous files

Conceptual MCP operation:

```text
capture(input, optional_hint)
```

Pipeline:

```text
input
  |
  v
extract / inspect
  |
  v
understand artifact
  |
  +--> subjects
  +--> entities
  +--> dates
  +--> source type
  +--> volatility
  +--> possible project relevance
  |
  v
search existing TheBrain + OB1
  |
  v
reuse canonical Thoughts where possible
  |
  v
propose minimal structure
  |
  +--> high confidence: commit
  +--> meaningful ambiguity: ask user
```

## 7. Preserve Intent Even When Enrichment Fails

A capture request is successful when the **user’s intent is preserved**, not only when every automated extraction succeeds.

Example: YouTube transcript retrieval often fails with HTTP `429 Too Many Requests`.

Correct behavior:

```text
URL received
metadata saved
transcript attempted
  |
  +--> success: attach transcript
  |
  +--> HTTP 429:
       preserve source + user note
       tag Thought = Incomplete
       record failure detail
       retry later with backoff
```

Suggested retry pattern:

```text
5 minutes
30 minutes
2 hours
12 hours
next day
```

Do not hammer YouTube.

Human-visible state should be a Tag such as:

- Incomplete
- Needs Review

Detailed retry/failure state can live in Notes or CRO runtime metadata.

When successful, remove `Incomplete` and optionally add `Complete`.

Useful user query:

> “Show me anything I captured that is incomplete.”

## 8. Source Preservation

External archives are not durable enough to be the only source copy.

When material matters, preserve locally in TheBrain:

- original URL
- access date
- downloaded source/attachment
- transcript/captions
- screenshot when layout/context matters
- summary in Notes
- optional checksum/hash
- archive/Wayback URL as secondary reference

Rule:

> Keep the dead URL, but preserve the source locally when it matters.

## 9. Graph Hygiene

TheBrain became overwhelming for the user in the past because manual graph maintenance did not scale.

CRO must act as the graph librarian.

The user should not have to remember:

- where a Thought belongs
- what it should connect to
- whether a similar Thought already exists
- which old relationship convention was used
- what changed months or years ago

CRO should:

- aggressively reuse existing Thoughts
- check for near-duplicates before creating
- create only a small number of high-value links
- avoid “everything connects to everything”
- find orphan Thoughts
- identify duplicate/near-duplicate Thoughts
- identify stale/obsolete software-version Thoughts
- identify pathological high-degree hub nodes
- detect contradictory relationships
- surface cleanup as propose/review/execute rather than destructive automation

Core principle:

> The user supplies knowledge. The orchestrator maintains graph hygiene.

And:

> If maintaining TheBrain requires remembering its structure, the system has inverted its purpose.

## 10. Large Anchor Subjects

The user has broad durable subject anchors, for example:

### GRIN / Transhumanism

Partial/full integration of:

- Genetics
- Robotics
- Intelligence / AI
- Nanotechnology

(Traditional GRIN often uses “Information,” but preserve the user’s preferred ontology rather than “correcting” it.)

### Other major anchors

- Space
- Technology
  - software development
  - architecture
  - AI
- Adrenaline activities
  - skydiving
  - other activities may be added later

These are good Plex anchor Thoughts.

CRO should preferentially reuse established anchors rather than inventing new taxonomy.

## 11. Repositories and Creative Work

The user deliberately keeps project work in repos because:

- the material stays close to the project
- the user knows where most things are
- AI can inspect one repo and recover context
- skills and runbooks evolve frequently
- project canon remains explicit

CRO should **not** replace this.

The user does **not** want autonomous front-to-back story generation.

The user wants to stay deeply involved in:

- idea development
- character cards
- worldbuilding cards
- plot arcs
- series structure
- act structure
- book structure
- chapter planning
- scene planning
- drafting
- editing

The user already has multiple skills for these steps.

CRO should walk alongside as a co-author/research aide, not take over authorship.

## 12. Skill Integration — Automatic Context Lookup

This is a key MVP feature.

When a skill begins, CRO should automatically ask:

> “What does the user already know, remember, or have parked that may matter to this step?”

The user should not have to prompt:

> “Please see if I have anything related to this.”

### Pre-skill context hook

Conceptually:

```text
1. Identify current project
2. Identify current skill
3. Identify current subject/artifact
4. Read author-declared repo references
5. Build working semantic context
6. Search TheBrain
7. Search OB1
8. Return compact relevance-ranked context packet
9. Skill proceeds
```

### Post-skill memory hook

After work completes, detect:

- new decisions
- new canon
- unresolved questions
- parked ideas
- research needs
- contradictions
- tasks

Then propose appropriate persistence:

```text
repo      -> approved project/canon material
TheBrain  -> durable knowledge/source/evidence
OB1       -> loose idea/observation/task/reference
```

Do not silently promote brainstorms into canon.

## 13. Retrieval Order for Creative Skills

Use author-declared project relationships before inferred relationships.

Example Chapter Outline Card includes:

- current chapter
- explicit Character Cards
- explicit Worldbuilding Cards
- plot/scene beats
- date
- thematic constraints

That outline is effectively a **retrieval manifest**.

Retrieval order should be:

```text
current chapter/scene/card
        |
        v
follow explicit repo references
        |
        v
build working semantic context
        |
        +--> semantic repo search for additional likely material
        |
        +--> TheBrain search
        |
        +--> OB1 search
        |
        v
surface relevant forgotten/parked material
```

This keeps retrieval grounded in the user’s authored story architecture.

## 14. Example: The Fractured Horizon — Book 1, Chapter 2

The current Chapter 02 planning artifact explicitly references:

### Characters

- Jonathan Rose
- Leslie Emi Sorrens

### Worldbuilding

- The Rose Homestead
- Laboratoire Biologique de la Désirade
- Quantum-Assisted Genetic Editing (QAGE)
- Neural Assistants
- Devin’s Encryption Suite

The user may not remember that a QAGE worldbuilding card exists. That is fine.

The outline already declares QAGE as relevant.

CRO should follow that reference automatically when a chapter/scene skill runs.

## 15. Parked Idea Example — Whole-Cell Simulation

Recent user idea:

A 2026 scientific advance simulated the full life cycle of the minimal bacterial cell `JCVI-syn3A`.

The captured transcript says:

- 493 genes
- gene activity simulated
- energy use simulated
- growth simulated
- DNA copying simulated
- cell division simulated
- full ~105-minute cell cycle
- simulation required ~6 days of computer time

The user’s creative intent:

> Consider using this 2026 whole-cell simulation work as a historical precursor/reference for the genomic procedures Jon and Jen undergo in *The Fractured Horizon* Book 1.

Important separation:

### Source/research

Durable research/evidence belongs in TheBrain.

### Creative idea

The story-use concept is a parked idea and belongs naturally in OB1 until accepted into canon.

### Repo

The repo should remain unchanged until the user explicitly decides to integrate the idea.

### Desired future behavior

When the user later works on Chapter 2, QAGE, Jon/Jen genomic treatment, La Désirade, etc., CRO should surface:

> “You previously parked an idea to use the 2026 JCVI-syn3A whole-cell simulation as historical ancestry for this technology. It has not been integrated into canon.”

CRO should **surface**, not silently insert.

## 16. Cross-Cutting Impact Detection

Two reciprocal capabilities matter greatly:

### Impact forward

When something new is captured:

> “What existing project material could this matter to?”

### Recall backward

When the user works on an artifact:

> “What previously captured material could matter here?”

These are likely more valuable than a large autonomous workflow engine.

## 17. Serendipity Retrieval

Not all useful relationships share keywords.

Example:

```text
whole-cell simulation
  -> genetics
  -> biological modeling
  -> genomic manipulation
  -> QAGE
  -> Jon/Jen procedure
```

CRO should reserve some retrieval capacity for “possibly relevant older thought” rather than returning only literal/direct matches.

This is where TheBrain’s graph plus OB1 semantic search can complement repo context.

## 18. Existing CRO Repo Needs Revision

The current repository was originally designed around a three-system model:

- Karakeep = source repository
- TheBrain = associative graph
- OB1 = durable personal/contextual memory

That model is now superseded.

### New decision

**Drop Karakeep.**

TheBrain replaces Karakeep’s source/evidence role because:

- files can be attached directly to Thoughts
- Notes can store synthesized context
- URLs can be stored
- the Plex provides the associative structure
- the Local API can be used for automation

The repo documentation, diagrams, ADRs, capability matrix, and capture flows should be reviewed for stale Karakeep assumptions.

Do not mechanically replace “Karakeep” with “TheBrain”; first reconcile the ownership rules described in this handoff.

## 19. TheBrain Local API

The local API is available from the desktop app:

**Settings -> User -> Local API**

That page provides:

- localhost endpoint
- local API key
- example request
- API documentation link
- key show/copy/regenerate controls

The local API key is device-specific and remains local.

CRO should use the Local API rather than directly manipulating TheBrain’s internal database/files.

## 20. TheBrain API Capability Matrix — Must Be Verified

Before implementation, inspect the installed Local API docs and document read/write support for:

| Capability | Read | Write | Notes |
|---|---|---|---|
| Thoughts | ? | ? | |
| Thought Types | ? | ? | |
| Tags | ? | ? | |
| Notes | ? | ? | |
| Attachments | ? | ? | |
| Parents/Children/Jumps | ? | ? | |
| Link Types | ? | ? | |
| Link direction/properties | ? | ? | |
| Native timestamps/history | ? | ? | |
| Calendar Events | ? | ? | |
| BrainBox | ? | ? | |
| Search | ? | ? | |
| Bulk operations | ? | ? | |

Do not assume that every desktop UI feature is currently exposed via API.

## 21. OB1 Capability Summary

Current exposed OB1 operations include:

- semantic search
- fetch thought by ID
- search thoughts
- list recent thoughts
- statistics
- capture thought

Captured thoughts automatically receive embeddings/metadata.

Known classes:

- observation
- task
- idea
- reference
- person_note

The designer (Nate B. Jones) appears to orient OB1 heavily toward ongoing human work/operations, but for this project it should be used as a personal semantic thought stream rather than a company-only system.

## 22. What CRO Should Not Do

Do not:

- create a third durable knowledge store
- copy repo files into TheBrain automatically
- copy TheBrain sources into OB1
- dump every extracted fact into the Plex
- create a Thought for every entity mentioned in a source
- create dozens of graph links because they are semantically plausible
- turn brainstorms into canon
- rewrite project files merely because a potentially relevant idea was found
- run the entire story workflow autonomously
- require the user to remember where something belongs before capture
- discard a capture because an enrichment step failed
- silently “correct” the user’s personal ontology
- depend on external archive services as the only durable copy

## 23. Strong Design Principles

These statements should guide implementation:

> CRO owns behavior and orchestration, not knowledge.

> The repo tells CRO what the user is working on. TheBrain tells it what the user knows. OB1 tells it what the user has thought about. CRO notices the intersections.

> Use author-declared project relationships before inferred relationships.

> Facts are cheap. Plex nodes and links are expensive.

> Put knowledge inside the Thought. Put relationships in the Plex.

> A fact does not become a Thought merely because CRO extracted it.

> Notes are the synthesized knowledge representation; attachments are the lossless source representation.

> The user supplies knowledge. The orchestrator maintains graph hygiene.

> If the user has to remember where something belongs before saving it, CRO has failed.

> CRO reads everything relevant. The Plex contains only what is worth navigating.

> Surface speculative/parked ideas; do not silently incorporate them.

## 24. Suggested MVP Tool Surface

Keep MCP tools task-oriented rather than exposing TheBrain mechanics directly.

Possible initial surface:

```text
capture(input, optional_hint)

recall_context(
    project,
    current_artifact,
    skill_or_task,
    subjects
)

find_related(query)

find_when(query)

explore(topic)

review_incomplete()

review_stale()

suggest_connections(thought)

explain_path(source, target)
```

Internally CRO may call lower-level TheBrain/OB1/repo operations, but clients should not need to know those APIs.

## 25. Immediate Next Step for Codex

Do **not** begin broad implementation yet.

First:

1. Read the existing CRO repository completely enough to understand:
   - README
   - architecture docs
   - ADRs
   - diagrams
   - capability matrix
   - capture flows
   - MCP/tool design
   - any Karakeep-specific code/design assumptions

2. Compare the current repo against this handoff.

3. Produce a **gap analysis** grouped into:
   - documentation changes
   - architecture changes
   - API discovery needed
   - data ownership changes
   - MCP surface changes
   - capture pipeline changes
   - skill integration changes
   - open questions

4. Specifically identify every place where Karakeep is still treated as canonical.

5. Propose a minimal set of repo edits to bring the design into alignment.

6. Do not make destructive/bulk changes until the user approves the plan.

## 26. Open Questions

These are intentionally unresolved:

1. Exact TheBrain Local API support for:
   - Link Types
   - Calendar Events
   - Notes
   - Attachments
   - timestamps/history
   - BrainBox

2. Whether Month/Year Thoughts should remain exactly as-is or be partially normalized after API capabilities are understood.

3. How much CRO-generated metadata should live in Notes versus Tags versus runtime state.

4. Whether `Complete` should be an explicit Tag or absence of `Incomplete` should imply complete.

5. How CRO should represent source volatility:
   - history/biography = low volatility
   - established science = low
   - recent science = medium
   - software = high
   - AI tools/models = very high

6. Whether repo awareness needs a rebuildable semantic cache for speed or can remain on-demand for MVP.

7. How skills should declare CRO context requirements:
   - YAML block in skill
   - standard pre/post hook
   - separate policy file
   - another mechanism

8. How far “serendipity retrieval” should roam before it becomes distracting.

---

## Short Prompt to Give Codex

Use this after opening the CRO repo:

> Read `CRO-DESIGN-HANDOFF-2026-10-11.md` first. Treat it as the current architecture/design decision record for this session. Then inspect the existing repository and produce the gap analysis requested in section 25. Do not start broad implementation or destructive refactoring until I approve the plan.
