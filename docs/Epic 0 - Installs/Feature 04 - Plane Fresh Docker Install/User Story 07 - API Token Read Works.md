# User Story 07 — API Token Read Works

**Status:** Done 2026-11-06

**Story:** As the CRO developer, I want an API token and one working read call, so Feature 06 (Plane MCP) has proven groundwork.

**Done when:** A token is created in Plane, a GET to the work-items API returns an empty list for the CRO project. The token is stored in User Secrets, not the repo.

**Notes:** Keith created a token in Plane and stored it with dotnet user-secrets (key Plane:ApiToken); it was never pasted into chat or the repo. Header is X-API-Key. GET /api/v1/users/me/ returned 200. The workspace slug is cro; GET /api/v1/workspaces/cro/projects/ lists project CRO, and GET .../projects/{id}/work-items/ returns 200 with an empty results list. Note for Feature 06: the API path says work-items (not issues) in this version.
