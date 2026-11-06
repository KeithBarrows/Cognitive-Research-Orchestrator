# User Story 07 — Resolver Survives a Reboot

**Status:** Not started

**Story:** As the CRO developer, I want the resolver to come back after the laptop reboots, so DNS does not need a manual start.

**Done when:** After a reboot, Docker Desktop and dnsmasq start on their own and the lookups in Stories 03 and 04 still work.

**Notes:** Depends on Docker Desktop starting at login and on `up.cmd` or a restart policy bringing the container back.
