# Writing Program and Author HQ Living Doc

Living document. Started 2026-08-07. Add/remove freely; first real revisit expected in 1–2 months per original instruction.

Relationship between the two lists: List 1 is the actual author workflow — the steps a book (or newsletter issue) moves through. List 2, the Author HQ / second brain, is the tracking system that sits underneath and around that workflow, and it doesn't stop at authoring — it also tracks pen names, personal projects (Homestead, Health, etc.), goals, and admin/legal threads. The Cognitive Research Orchestrator (CRO) described under List 2's App Integration Map is the shared backend being built to support List 1's author workflow *and* every other personal project — not an author-only system.

---

## List 1: Writing Program — Idea to Published Book Workflow

A usable set of steps, raw idea to published book, each mapped to its JT Kaelen Plane pipeline state where one exists.

| # | Step | Plane state | Purpose | Status |
|---|---|---|---|---|
| 0 | **Idea Capture** | *(pre-Backlog)* | Raw idea captured — pen name assigned, genre/series determined, saved as an OB1 engram and/or filed as a Plane Backlog work item | Built |
| 1 | **Book Arc** | Book Arc | Define the high-level arc/premise, position it within the series, rough target date | Built (state exists; process not yet formalized) |
| 2 | **Outlines** | Outlines | Chapter-by-chapter outline; check against existing series continuity (characters, timeline, worldbuilding) | State built; continuity check itself still needs a formal tracked structure |
| 3 | **Drafting** | Drafting | Chapter-by-chapter drafting, supported by the pen name's voice profile | Built (voice profile exists for JT Kaelen); TheBrain-backed worldbuilding lookup during drafting still planned (via CRO) |
| 4 | **Developmental Edit** | Developmental Edit | Big-picture revision — structure, pacing, character arcs | State exists; workflow itself is manual today |
| 5 | **Line Edit** | Line Edit | Sentence-level revision | State exists; manual |
| 6 | **Copy Edit** | Copy Edit | Grammar, consistency, style-guide pass | State exists; manual |
| 7 | **Proofread** | Proofread | Final read-through before formatting | State exists; manual |
| 8 | **Publication Ready** | Publication Ready | Front/back matter, cover finalized, metadata prepped | State exists; manual |
| 9 | **ePub Created (Beta)** | ePub Created (Beta) | Format conversion, beta review pass | State exists; manual |
| 10 | **Published (KDP)** | Published (KDP) | Uploaded and submitted to KDP | State exists; manual |
| 11 | **KDP Live** | KDP Live | Live and purchasable | State exists; manual |
| 12 | **Launch Support** | *(post-KDP Live, ongoing)* | "Next Book" launch-signal drafts, weekly newsletter mentions, banner-image generation for ongoing coverage | Built for JT Kaelen (newsletter pipeline, banner prompt generator, "Next Book" prototype) |

### Nice to Have (not blocking any step above)
- AI co-writing assistance that stays inside voice-profile guardrails rather than generating prose wholesale
- Cross-link between a chapter/scene and its Plane work item, so drafting progress is visible without leaving the editor
- Beta reader feedback loop (structured intake → tagged by chapter/character/theme), feeding step 9
- Series "throughline" dashboard — pull each series' current arc status (step 1) into one cross-series view
- CRO-backed source lookup while drafting research-heavy scenes, using repo context, TheBrain evidence, and OB1 parked ideas

### Not Needed
- Built-in publishing/distribution inside the writing tool — KDP and Substack already handle steps 10–12
- Social media scheduling — separate tool if ever needed
- Full project management inside the writing tool itself — Plane already owns steps 1–11; the writing tool should feed it, not duplicate it
- Multi-user/collaboration features — single-author operation

### Sequencing
- **Now:** formalize the continuity check at step 2 (Outlines), tighten chapter-to-state sync at steps 3–7
- **Next (1–2 months):** beta reader loop (feeding step 9), throughline dashboard
- **Later:** CRO-backed TheBrain lookup during drafting (step 3), AI co-writing guardrail refinement — CRO itself is still concept-stage, Phase 0/technical discovery not started

---

## List 2: Author HQ / Second Brain — What It Tracks

For each tracked thing: the properties it needs.

1. **Works in Progress (Books)**
   Pen name · Series · Book # · Title · Genre · Status (List 1 pipeline step) · Target date · Word count / chapter count · Act structure · Cover art path · Production Tracker work item ID

2. **Series**
   Pen name · Title · Book count · Status (active/paused/complete) · Visual motif (banner reference) · Throughline summary · Cover-art folder path

3. **Pen Names / Identities**
   Name · Genre/niche · Voice profile reference · Newsletter (name, cadence, platform) · Socials · Associated business entity

4. **Newsletter Issues**
   Pen name · Publish date · Status (draft/published) · Banner asset path · Sections included · Associated Gmail draft ID (if applicable)

5. **Reading / Watching / Listening** (existing: "What's Fueling The Work")
   Title · Medium (Audible/Kindle/TV/etc.) · Author/Creator · Status (queued/in-progress/finished) · Newsletter mention count

6. **Characters**
   Name · Series · Role · Arc status · Relationships · Continuity notes

7. **Worldbuilding Elements**
   Type (tech/location/faction/concept) · Series/cross-series scope · Description · Related Battle Space(s) (existing framework) · Source engram reference

8. **Goals**
   Title · Category (Work / Business / Personal — Personal further split into Health, Relationships, Finances) · Target date · Status · Steps to achieve · Why (motivation/rationale)

9. **Infrastructure / Tooling Tasks** (existing: Plane Infrastructure project)
   Title · Module (AI Workflows, etc.) · Status · Related skill/recipe · Priority

10. **Business Entities**
    Entity name (e.g. Quantum Fracture Creative Group, LLC) · Associated pen names · Financial/contract references · Status

11. **Legal / Admin Threads** (existing: Starlink dispute, letters)
    Title · Type (dispute/correspondence/filing) · Status · Related documents · Deadline

12. **Life Timeline** (TheBrain-native, surfaced through CRO)
    Event · Date · Category (personal/professional/creative milestone) · Related goal or project · Notes · TheBrain thought ID (native identifier, not duplicated into OB1 per CRO's "link don't duplicate" principle)

13. **Quivers / Arrows** (confirmed TheBrain naming convention, not a formal 3-tier system)
    "Quiver" and "Arrow" are naming idioms Keith applies to particular thoughts, not a rigid schema — the "another arrow in my quiver" framing, where a full quiver is a complete toolbox of info/experience on a topic. A **Quiver** thought (e.g. "Quiver Software Development," "Quiver My Tools," "Quiver OS Management") groups a topic/toolbox; its child **Arrow** thoughts (e.g. "Arrow AutoMapper," "Arrow CQRS," "Arrow Domain Driven Design") are individual named pieces of knowledge, technique, or tooling within that toolbox. There's no separate formally-named "Bucket" tier — broader persona/topic nodes like "Technologist & ASPInsider" or "Computer sciences" sit above Quivers in the plex but aren't a distinct named type, just organizational parents.
    Properties per Arrow: Name · Parent Quiver · Type (technique/tool/reference/pattern) · Linked attachments (docs, links) · Related thoughts (jumps)
    Properties per Quiver: Name · Domain/topic · Parent persona/topic node · Arrow count · Status (active toolbox / archived)

14. **Personal Projects** (non-authoring — Homestead, Health, etc.)
    Project name · Domain (Homestead/Health/Finance/etc.) · Status · Related goal(s) (item 8) · Notes — same tracking shape as authoring work, just outside the book pipeline

15. **Research Sources / Evidence** (TheBrain, orchestrated by CRO)
    URL · Source publication date · Captured/access date · Compact summary in Notes · Original attachment or transcript · User-visible state (`Incomplete`, `Needs Review`, `Stale`, `Superseded`, or `Historical` where applicable) · Why saved · Computed technical currency/volatility · Related TheBrain Thoughts · Related OB1 idea, observation, task, or reference when applicable. Normal completion is the absence of `Incomplete`; there is no `Complete` tag.

---

## App Integration Map

This is List 2's engine room — what Author HQ (and every other personal project it tracks) actually runs on.

**Current**
- OB1 (Obi Wan/Supabase) — engram storage, source of truth for fingerprints/recipes/scope
- Plane.so — work item tracking (JT Kaelen production, Infrastructure, Author Operations, Quantum Fracture Press sandbox)
- Gmail — newsletter drafts, daily brief email scan
- Google Calendar — daily brief, appointment flagging
- Git/journal (CreativeOS repo) — monthly logs, commit history
- Scheduled tasks (Cowork) — daily brief, weekly newsletters (JT + Keith)

**Planned — via the Cognitive Research Orchestrator (CRO)**
Concept-architecture repo already exists at `D:\Repos\KeithBarrows\Cognitive Research Orchestrator` (status: approved concept/technical design, no implementation yet). It's a local-first MCP orchestration layer, not another knowledge store. Project repositories own project work and canon, TheBrain owns durable knowledge and evidence, OB1 owns the semantic thought stream, and CRO owns only orchestration plus bounded operational/rebuildable state. This is the shared backend meant to support List 1's author workflow *and* every other personal project tracked in List 2 (Homestead, Health, Finances, etc.) — it is not author-specific.

| System | Role in CRO's cognitive model | Owns |
|---|---|---|
| Project repositories | Project truth | Approved manuscripts, cards, canon, decisions, skills, runbooks, and deliberately project-local research |
| TheBrain | Durable knowledge and associative graph | Sources, attachments, Notes, concepts, people, projects, technologies, life timeline, Quivers/Arrows, and meaningful relationships |
| OB1 | Semantic inbox and thinking history | Ideas, observations, tasks, references, person notes, and durable reading/resurfacing reactions |
| CRO itself | Attention and orchestration | Capture routing, context assembly, relevance, resurfacing, graph-hygiene suggestions, and bounded operational state |

Core CRO principles worth carrying into how Author HQ evolves: use explicit repo relationships before inference, link rather than duplicate, preserve per-system ownership, keep evidence distinct from inference, preserve capture intent when enrichment fails, and never silently promote parked ideas into canon. High-confidence source capture may create or reuse TheBrain Thoughts automatically; CRO asks when ambiguity is material.

CRO's own phased plan (nothing built yet, all still ahead):
0. Technical discovery — including inspecting the live TheBrain local API and finalizing the skill context block
1. Read-only repo-grounded context recall
2. General capture for URLs, files, text, and ideas
3. Incomplete-capture recovery and graph hygiene
4. Temporal relevance and bounded resurfacing
5. Skill hooks and controlled project writes with bounded operational audit history

Once CRO reaches Phase 1+, both List 1's drafting-time lookups (step 3, worldbuilding) and List 2's broader "pull relevant context into any personal project" need can ride on CRO's MCP surface instead of needing custom integration work per project.

---

## Notes
- Quiver/Arrow naming confirmed directly from a live TheBrain screenshot (2026-08-07): Quiver = topic/toolbox thought, Arrow = individual knowledge/tool/technique thought nested under it. No formal "Bucket" tier exists.
- Karakeep was evaluated and removed from the CRO architecture on 2026-10-11. TheBrain owns durable sources and evidence.
- This file lives outside OB1 on purpose — it's a working scratchpad meant to be edited freely; promote settled pieces into OB1 engrams once they stabilize.
- Superseded location: an earlier draft of this file was written to `D:\Repos\QFCG\CreativeOS\_Personal\author-hq-two-lists.md` before being moved here to live alongside the CRO architecture it depends on. That copy can be deleted.
