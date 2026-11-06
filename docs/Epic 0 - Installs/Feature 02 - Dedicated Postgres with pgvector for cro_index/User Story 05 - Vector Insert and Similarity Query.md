# User Story 05 — Vector Insert and Similarity Query

**Status:** Done 2026-11-05

**Story:** As the CRO developer, I want to store and compare
`vector(384)` values, so I know embeddings work.

**Done when:** A `vector(384)` row inserts and a similarity query
returns the closer row first.

**Notes:** The first test used cosine distance on parallel vectors,
so both scored about zero. That test was too weak. The L2 re-run
ranked correctly (0.39 vs 15.28), on the old named volume and again
on the D: drive bind mount (`D:\Data\CRO\cro-index-postgres`).
