# User Story 08 — Schema Takes a Real Chunk

**Status:** Done 2026-11-05

**Story:** As the CRO developer, I want a real `chunks` row with a
`vector(384)` embedding, so the schema is proven, not just created.

**Done when:** One chunk inserts and a similarity query finds it.
Test rows are removed afterward.

**Notes:** Inserted two chunks (near and far) with `vector(384)`
embeddings. The similarity query ranked near first (0.3919 vs
15.2848). Test rows deleted afterward. After `V004` (2026-11-05) the
test was re-run at 768 dimensions: near 0.5543, far 21.6160; a
384-dimension insert is rejected.
