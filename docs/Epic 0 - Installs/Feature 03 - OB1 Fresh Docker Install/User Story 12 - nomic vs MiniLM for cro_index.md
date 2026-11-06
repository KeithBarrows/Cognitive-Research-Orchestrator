# User Story 12 — nomic vs MiniLM for cro_index

**Status:** Done 2026-11-05 (closed by the user's decision; no
side-by-side comparison was run)

**Story:** As the CRO developer, I want to compare `nomic-embed-text`
with `all-MiniLM-L6-v2`, so I choose the better vector model for
`cro_index` while it is cheap to change.

**Done when:** Both models are run on the same sample texts, and speed
and ranking quality are recorded here, with a recommendation.

**Notes:** Closed 2026-11-05 by the user: the larger model
(`nomic-embed-text`, 768 dimensions) runs fast enough on this laptop
(Story 06 timings), so no comparison is needed now. **Future
research:** if the model seems to degrade (poor ranking, slow, or
dimension problems), revisit with a real comparison against
`all-MiniLM-L6-v2` on the same texts. Follow-up 2026-11-05:
`cro_index` switched to `nomic-embed-text` (768 dimensions) by
migration `V004`; see `DECISIONS.md`. Idea from the user, 2026-11-05.
