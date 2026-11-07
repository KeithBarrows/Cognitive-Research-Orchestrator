# User Story 01 — Choose the Plane MCP Server

**Status:** Done

**Story:** As the CRO developer, I want to pick the Plane MCP server and how it runs on the laptop, so I know what to install before connecting it.

**Done when:** One server is chosen (official Plane MCP or a community one), with how it starts (container, `npx` or `uvx`) and its transport written here.

**Chosen:** The official Plane MCP server, `plane-mcp-server`
(github.com/makeplane/plane-mcp-server). It runs locally, never the
cloud.

**How it starts:** `uvx plane-mcp-server stdio`, started by the MCP
client as a subprocess. Needs Python 3.10+ and `uv`.

**Transport:** stdio. The hosted HTTP transports at `mcp.plane.so`
are not used.

**Settings:** `PLANE_BASE_URL=http://localhost:8090`,
`PLANE_WORKSPACE_SLUG=cro`, `PLANE_API_KEY` from User Secrets
(`Plane:ApiToken`).

**Not changed:** CRO stays the sole MCP surface after bootstrap
(`DECISIONS.md`). This connection is an Epic 0 trial and development
tool only.

**Notes:** Served from the laptop only. Treat this as an Epic 0 trial and development tool; `DECISIONS.md` says CRO is the sole MCP surface on this machine after bootstrap, so record that this connection does not change that.
