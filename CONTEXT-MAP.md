# Available context map

| Source | Location | Authority | Freshness | Load when | State |
| --- | --- | --- | --- | --- | --- |
| Current design addendum | `CRO-DESIGN-ADDENDUM-2026-10-11.md` | Canonical for architecture decisions made after the handoff | 2026-10-11 | Any architecture, security, storage, retrieval, or scope decision | Active |
| Original design handoff | `CRO-DESIGN-HANDOFF-2026-10-11.md` | Canonical unless superseded by the addendum or verified capability findings | 2026-10-11 | Need original rationale, examples, or feature intent | On demand |
| Technical architecture | `docs/README.md` | Canonical consolidated architecture | Updated 2026-10-11 | Planning or reviewing CRO behavior and delivery phases | Active |
| Capability matrix | `docs/capability-matrix.md` | Canonical for verified TheBrain, OB1, and repository-adapter behavior | Verified 2026-10-11 | Designing an adapter, fallback, failure path, or acceptance test | Active |
| Storage-boundary ADR | `docs/adr/0001-data-ownership-and-storage-boundaries.md` | Canonical for ownership and persistence boundaries | Accepted 2026-10-11 | Any storage, indexing, capture, or persistence decision | Active |
| Architecture diagrams | `docs/architecture/*.mmd` | Supporting visual representation | Updated 2026-10-11 | Reviewing flows, boundaries, or component relationships | On demand |
| Repository overview | `README.md` | Canonical concise project orientation | Updated 2026-10-11 | Session orientation or external project summary | Active |
| Epic roadmap | `docs/phase-roadmap.md` | Overview of all 7 Epics (0-6; renamed from "phases" 2026-11-04) plus cross-cutting decisions (language, schema, doc-review task, Plane tagging convention) | Updated 2026-11-04 | Orienting across Epics, or needing the language/schema/doc-review decisions that apply project-wide | Active |
| Epic 0 plan | `docs/phase-0-plan.md` | Epic 0 (Installs) plan — infrastructure only, no CRO code | Added 2026-11-04 | Reviewing what needs installing (Docker, Postgres+pgvector, OB1, Plane, TheBrain file sync) before Epic 1 can run | Active |
| Epic 1 plan | `docs/phase-1-plan.md` | Epic 1 (Bootstrap) plan — still needs approval | Still needing approval as of 2026-11-04 | Reviewing the Epic 1 bootstrap slice, its schema touch, tests, or exclusions | Active, not yet approved |
| Epic 2-6 plans | `docs/phase-2-plan.md` .. `docs/phase-6-plan.md` | Broad-stroke only, not yet detailed | Named 2026-11-04 (Epic 6 added 2026-11-04) | Reviewing Lookup+Plane, ongoing capture, reorg, external-gather, or skill-hooks scope | Broad-stroke |
| `cro_index` schema | `docs/cro-index-schema.md` (canonical copy of the diagram: `docs/architecture/09-cro-index-schema.mmd`) | Canonical for the 10-table `cro_index` schema — settled through live verification against TheBrain, OB1, and Plane | Settled 2026-11-04 | Any `cro_index` table, column, embedding, or chunking question | Active |
| Developer architecture overview | `docs/developer-architecture-overview.md` | Summary/index pointing to the canonical sources below; not itself a decision source | Written 2026-10-22 | Onboarding a new developer, or wanting one page that links everything | Active |
| OB1 integration survey | `docs/ob1-integration-survey.md` | Reference catalog of OB1's extensions/recipes/schemas; not itself a design decision | Written 2026-10-16 | Checking whether an OB1 capability already exists before designing one | On demand |
| Scouting notes | `docs/research/*.md` | Raw tool/API scouting notes, not a design decision; rescued 2026-10-20 from a stale duplicate folder | Dated individually, pre-2026-10-20 | Designing the future health-device ingestion item, or checking whether a scouted tool was already looked at | On demand |
| Shared startup contract | `D:\Repos\.ai-config\startup.md` | Canonical cross-repository startup procedure | Verified 2026-10-11 | Every new session after bootstrap migration | Active |
| Repository bootstrap variables | `bootstrap.variables.md` | Canonical project scope after approval | Proposed 2026-10-11 | Every new session after creation | Pending approval |
| Git working state | Git status and diffs | Canonical for uncommitted repository state | Live | Before edits, tests, cleanup, or commits | Active |
| Project journal | `.journal/journal.md` | Curated project history | Updated 2026-10-11 | A journal retrieval trigger fires | On demand |
| Writing-program document | `docs/Writing Program and Author HQ Living Doc.md` | Supporting domain material, not CRO core architecture | Existing document | A writing integration specifically requires it | Excluded by default |

## Source precedence

Direct user instructions and approvals govern the current task.

For CRO design:

1. Verified capability behavior overrides conceptual assumptions.
2. The design addendum overrides the original handoff.
3. The consolidated architecture and accepted ADR express the current
   repository design.
4. Diagrams and the root README summarize those sources.

For operating instructions:

1. Mandatory shared rules override everything.
2. Project scope overrides identity, bucket, and Unified defaults.
3. `CURRENT.md` controls current state but cannot override approved
   architecture or verified capability behavior.

Stop and ask if this precedence does not resolve a conflict.

## Retrieval triggers

- A required definition, fact, capability, or acceptance test is missing.
- Two active sources conflict.
- A design relies on an unsupported or unclear adapter behavior.
- The task crosses a privacy, write, network, or canonical-ownership
  boundary.
- The working-tree state may overlap the requested change.
- A source may have been superseded.
- The user asks for broader history or rationale.

## Deliberate exclusions

| Source or category | Why excluded now | Condition for reconsidering |
| --- | --- | --- |
| Future public capture implementation | Architecture only; outside MVP | User explicitly starts that project after local ingestion is secure |
| Dashboards, backup automation, and local AI | Future platform direction | User explicitly brings one into scope |
| Home Assistant (home-assistant.io) | Reconsidered and brought into scope 2026-10-16; parked for a dedicated future pass, not designed | Already reconsidered — remove this row once a design pass starts |
| Repository write support | Initial MVP is read-only | Read-only retrieval succeeds and a separate write contract is approved |
| Arbitrary binary parsing | Requires restricted format-specific extractors | A supported format and safety policy are approved |
| Legacy `.ai` startup files | Superseded after shared-startup migration, but not yet safe to delete | New root bootstrap is verified and user approves archival |
| Full Git history | Unnecessary for routine context | A decision, regression, or provenance question requires it |

## Known gaps

- Embedding model and chunk-splitting rule are settled (2026-11-04,
  see `docs/cro-index-schema.md`); **ranking** across the three
  sources at query time is still not finalized — that's Epic 2's job.
- Skill `cro_context` validation rules are not finalized.
- Plane is listed by the shared startup but is not available in the
  current Codex session.
- The legacy `.ai` files have uncommitted changes and require a separate
  cleanup decision after migration verification.
- Live TheBrain API check (2026-10-15) against the user's real Brain
  confirmed Note-body search is unreliable, consistent with
  `docs/capability-matrix.md` — no capability-matrix change needed, but
  this is now confirmed against real data, not just test data.
