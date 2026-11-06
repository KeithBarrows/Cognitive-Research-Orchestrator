# User Story 03 — One Real Thought From Each Brain

**Status:** Done 2026-11-06

**Story:** As the CRO developer, I want to read one real Thought from each brain, so I know the synced files are working brains and not just copied bytes.

**Done when:** For each of the 8 brains, one Thought is fetched by id and returns its name and links.

**Notes:** For each of the 8 brains, GET /api/thoughts/{brainId}/{thoughtId} on the brain's home thought returned HTTP 200 with the Thought's name, dates and ids (8 of 8). Read only. Home Thoughts do not always carry the brain's name: Growth's is named Keith's Brain, and Blue Skies Unlimited's is named Success. Epic 1 should not assume a home Thought's name equals the brain's name.
