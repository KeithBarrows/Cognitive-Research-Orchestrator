# User Story 02 — Connect to the Local Plane

**Status:** Not started

**Story:** As the CRO developer, I want the Plane MCP pointed at the local Plane, so it talks to the CRO instance and not the cloud workspace.

**Done when:** The MCP is configured with base URL `http://localhost:8090`, workspace slug `cro` and the API token from User Secrets (`Plane:ApiToken`), and it starts without error.

**Notes:** The token must not be written into a config file in the repo. If the client needs it in an environment variable, set it for that session only, as `up.cmd` does.
