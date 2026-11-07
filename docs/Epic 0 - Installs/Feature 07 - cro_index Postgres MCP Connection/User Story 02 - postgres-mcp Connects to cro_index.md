# User Story 02 — postgres-mcp Connects to cro_index

**Status:** Done

**Story:** As the CRO developer, I want `postgres-mcp` running against `cro_index`, so I can try the broader candidate.

**Done when:** `src\Infra\postgres-mcp.cmd` starts `postgres-mcp`
(image `writenotenow/postgres-mcp:v3.1.0`) as a stdio process in a
throwaway container, joins the `02-cro-index-postgres_default` Docker
network, connects to `cro-index-db:5432`, reads the password from User
Secrets for that process only, and is listed in `.mcp.json` as
`postgres-cro`. It publishes no port.

**Notes:** Changed 2026-11-06 from a compose folder, for the same
reason as Story 01. It documents 278 tools; the launcher uses the
documented `--tool-filter codemode`. Confirm at smoke test that this
filter still lets it list the schema, insert and run a vector query;
if not, pick a different filter. Both candidates run at the same time
against the same database; that is safe because this is disposable
Docker.
Verified 2026-11-06: with --tool-filter codemode, pg_execute_code
listed the 11 tables plus flyway_schema_history, counted rows, and
inserted, queried and deleted rows. The codemode filter is enough for
schema, insert, vector query and delete.
