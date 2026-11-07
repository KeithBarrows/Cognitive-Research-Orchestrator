# User Story 05 — Pick a Winner and Remove the Other

**Status:** Done

**Story:** As the CRO developer, I want to keep one MCP server and remove the other, so only one extra container runs.

**Done when:** One candidate is chosen, the other's compose folder and container are removed, and the choice and reason are in `DECISIONS.md`.

**Notes:** No need to choose on paper first; the trial decides.
Decided 2026-11-06 (Keith): keep `postgres-cro`, remove `pgvector-cro`.
The "compose folder and container" in "Done when" no longer applies;
both servers became launchers on 2026-11-06. What was removed: the
`pgvector-cro` entry in `.mcp.json` and `src\Infra\pgvector-mcp.cmd`.
Reason and rollback: `DECISIONS.md`, 2026-11-06.
