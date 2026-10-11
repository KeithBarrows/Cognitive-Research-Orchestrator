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
| Shared startup contract | `D:\Repos\.ai-config\startup.md` | Canonical cross-repository startup procedure | Verified 2026-10-11 | Every new session after bootstrap migration | Active |
| Repository bootstrap variables | `bootstrap.variables.md` | Canonical project scope after approval | Proposed 2026-10-11 | Every new session after creation | Pending approval |
| Git working state | Git status and diffs | Canonical for uncommitted repository state | Live | Before edits, tests, cleanup, or commits | Active |
| Project journal | `journal/JOURNEY.md` | Curated history when entries exist | Currently contains no entries | A journal retrieval trigger fires | On demand |
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
| Home Assistant, dashboards, backup automation, and local AI | Future platform direction | User explicitly brings one into scope |
| Repository write support | Initial MVP is read-only | Read-only retrieval succeeds and a separate write contract is approved |
| Arbitrary binary parsing | Requires restricted format-specific extractors | A supported format and safety policy are approved |
| Legacy `.ai` startup files | Superseded after shared-startup migration, but not yet safe to delete | New root bootstrap is verified and user approves archival |
| Full Git history | Unnecessary for routine context | A decision, regression, or provenance question requires it |

## Known gaps

- Phase 1 implementation language and MCP SDK are undecided.
- Initial `cro_index` and `cro_runtime` schemas are not defined.
- Chunking, ranking, and embedding choices are not finalized.
- Skill `cro_context` validation rules are not finalized.
- Plane is listed by the shared startup but is not available in the
  current Codex session.
- The legacy `.ai` files have uncommitted changes and require a separate
  cleanup decision after migration verification.
