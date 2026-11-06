# User Story 08 — Survives Restart

**Status:** Done 2026-11-06

**Story:** As the CRO developer, I want Plane to come back with its data after a restart, so I can trust it.

**Done when:** After docker compose down and up.cmd, the admin login, the CRO project and the token still work.

**Notes:** Ran docker compose down (all containers and the network removed), then up.cmd. The stack was back in about a minute (the migrator only checks, so no slow migration this time). Afterwards the token still works (users/me 200), project CRO is listed, work-items returns 200, and the database still has the one user and one API token. The browser login itself was not tested by me. OB1 and cro_index stayed healthy.
