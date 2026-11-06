# User Story 04 — Insert and Vector Query Work

**Status:** Not started

**Story:** As the CRO developer, I want each candidate to insert a row and run a similarity query, so I know it handles `vector(768)`.

**Done when:** Each candidate inserts a test row into `chunks` with a 768-dimension embedding and returns it from a similarity query. The test rows are deleted afterwards.

**Notes:** Feature 02 Story 05 already proved this directly in Postgres; this story proves it through the MCP.
