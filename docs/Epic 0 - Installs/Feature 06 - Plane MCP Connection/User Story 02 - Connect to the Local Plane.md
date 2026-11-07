# User Story 02 — Connect to the Local Plane

**Status:** Done

**Story:** As the CRO developer, I want the Plane MCP pointed at the local Plane, so it talks to the CRO instance and not the cloud workspace.

**Done when:** The MCP is configured with base URL `http://localhost:8090`, workspace slug `cro` and the API token from User Secrets (`Plane:ApiToken`), and it starts without error.

**Notes:** The token must not be written into a config file in the repo. If the client needs it in an environment variable, set it for that session only, as `up.cmd` does.

**Result:** Configured as `plane-cro` in `.mcp.json`. It runs
`src\Infra\plane-mcp.cmd`, which sets `PLANE_BASE_URL=http://localhost:8090`
and `PLANE_WORKSPACE_SLUG=cro`, reads `Plane:ApiToken` from User
Secrets into `PLANE_API_KEY` for that process only, and starts
`python -m uv tool run plane-mcp-server stdio`. No token is in any
repo file. Smoke test 2026-11-06: the server starts and answers the
MCP initialize call (Plane MCP Server 3.2.0) with no errors.
