# User Story 09 — Data Survives Restart

**Status:** Done 2026-11-05

**Story:** As the CRO developer, I want the data to survive a
restart, so a reboot does not wipe cro_index.

**Done when:** After `docker compose down` then `up`, an earlier test
row is still there.

**Notes:** Inserted a marker row into `brains`, ran `docker compose
down` (no `-v`) then `up.cmd`. The row survived. Flyway reported "up
to date". Marker row deleted afterward.
