# User Story 03 — Lists Only the CRO Project

**Status:** Done

**Story:** As the CRO developer, I want the connection to list the CRO project and nothing else, so I know it is not the writing/CreativeOS workspace.

**Done when:** A project list through this connection returns exactly one project, CRO.

**Notes:** This is the check that matters most. The existing cloud Plane tools in this session point at the CreativeOS workspace.

**Result:** 2026-11-06: a project list through `plane-cro` returned
exactly one project, CRO (id `4fb65cf0-52db-49ef-91d8-a0af35ef5b94`).
The cloud `plane` connection returned four different projects
(AUTHOROPS, JTKAELEN, INFRA, QFP), so `plane-cro` is talking to the
local Plane, not the cloud workspace.
