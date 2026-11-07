# User Story 01 — pgvector MCP Connects to cro_index

**Status:** Done

**Story:** As the CRO developer, I want `mcp-server-pgvector` running against `cro_index`, so I can try the pgvector-specific candidate.

**Done when:** `src\Infra\pgvector-mcp.cmd` starts `mcp-server-pgvector`
(PyPI, pinned to 0.1.0) as a stdio process, connects to `cro_index` on
`127.0.0.1:5433`, reads the password from User Secrets for that
process only, and is listed in `.mcp.json` as `pgvector-cro`. It
publishes no port.

**Notes:** Changed 2026-11-06 from a compose folder: it is a Python
package that Claude Code launches, not a service. Author Praveen
Mittal (`mittalpk`), one release (2026-07-21), so it is pinned and
unvetted. Never use ports 80 or 443. It appears not to embed text, so
a query vector may have to be passed in; confirm in Story 04. The
launcher also pins `mcp<2` (`--with "mcp<2"`): 0.1.0 declares
`mcp>=1.12.0` with no upper bound, and on `mcp` 2.x it crashes at
startup (`mcp.server.fastmcp` was renamed). Found at the 2026-11-06
smoke test.
Verified 2026-11-06: through pgvector-cro, list_vector_tables found
chunks.embedding (768 dimensions) and describe_vector_table read
chunks. It connects to cro_index.
Removed 2026-11-06 after Story 05; see `DECISIONS.md`. Kept here as
the record of the trial.
