# User Story 02 — postgres-mcp Connects to cro_index

**Status:** Not started

**Story:** As the CRO developer, I want `postgres-mcp` running against `cro_index`, so I can try the broader candidate.

**Done when:** A compose folder `src/Infra/07b-mcp-postgres` starts it and connects to `cro_index` under the same rules as Story 01.

**Notes:** Both candidates run at the same time against the same database; that is safe because this is disposable Docker.
