# User Story 01 — pgvector MCP Connects to cro_index

**Status:** Not started

**Story:** As the CRO developer, I want `mcp-server-pgvector` running against `cro_index`, so I can try the pgvector-specific candidate.

**Done when:** A compose folder `src/Infra/07a-mcp-pgvector` starts it, it connects to `cro_index` on port 5433, the password comes from User Secrets, and any published port is on `127.0.0.1` only.

**Notes:** Never use ports 80 or 443. Connection string is built in `up.cmd`-style from User Secrets, not stored in the repo.
