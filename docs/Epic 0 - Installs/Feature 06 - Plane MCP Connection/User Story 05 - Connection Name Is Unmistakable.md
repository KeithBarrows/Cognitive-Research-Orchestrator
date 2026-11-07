# User Story 05 — Connection Name Is Unmistakable

**Status:** Done

**Story:** As the CRO developer, I want the new connection named so it can not be confused with the cloud Plane tools, so no tool call goes to the wrong workspace.

**Done when:** The new connection has a distinct name (for example `plane-cro`) and a note says which workspace each Plane connection points at.

**Notes:** This session already lists two Plane connections (`plane` and `claude.ai Plane`). Record which one points where.

**Result:** The new connection is named `plane-cro` (its tools appear
as `mcp__plane-cro__*`). Verified 2026-11-06 by project list:

| Connection | Points at | Projects |
|---|---|---|
| `plane-cro` | Local Plane, `http://localhost:8090`, workspace `cro` | CRO |
| `plane` | Cloud CreativeOS workspace | AUTHOROPS, JTKAELEN, INFRA, QFP |
| `claude.ai Plane` | Cloud CreativeOS workspace (same four project ids as `plane`) | AUTHOROPS, JTKAELEN, INFRA, QFP |

**Decision:** the cloud `plane` entry stays for now. Work items from the
cloud projects still have to be pulled into the local instance, which is
a large task and needs the OB1 integration working first. Revisit
removing the cloud entry after that migration.
