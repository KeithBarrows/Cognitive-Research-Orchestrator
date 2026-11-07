# User Story 03 — Each Lists the Schema

**Status:** Done

**Story:** As the CRO developer, I want each candidate to show the `cro_index` schema, so I know it sees the real tables.

**Done when:** Each candidate lists the 11 tables created by migration `V002`, and `flyway_schema_history`.

**Notes:** The Feature file said 8 tables; corrected to 11 on 2026-11-06.
Verified 2026-11-06: postgres-cro listed all 12 (the 11 tables plus
flyway_schema_history). pgvector-cro listed the one vector column,
chunks.embedding, 768 dimensions.
