# User Story 07 — Create the cro_index Schema

**Status:** Done 2026-11-05

**Story:** As the CRO developer, I want all 11 schema tables created,
so Epic 1 has a real place to write.

**Done when:** The SQL from `docs/cro-index-schema.md` runs with no
errors and `\dt` lists 11 tables.

**Notes:** Feature 02's text says 8 tables; the schema doc says 11.
All 11 are created by `migrations\V002__create_schema.sql`, plus the
3 seed rows in `V003`. Verified: `\dt` lists the 11 tables plus
Flyway's `flyway_schema_history`.

**Schema change standard (decided 2026-11-05):** versioned, forward-
only SQL migrations in
`src\Infra\02-cro-index-postgres\migrations\`, applied by the Flyway
`migrate` service in the compose file.
- Never edit a migration that has run. Flyway fails on a changed file.
- Every change is a new file, named `V004__short_description.sql`,
  `V005__...`, and so on. Add, change, or drop a column or table with
  `ALTER TABLE` / `DROP`. Add a join with `ALTER TABLE ... ADD
  CONSTRAINT ... FOREIGN KEY`.
- Seed data gets its own file.
- Flyway records what ran in `flyway_schema_history`.
- Epic 1 uses Npgsql, so EF Core migrations were not chosen. DbUp
  inside CRO can later run the same files unchanged.
