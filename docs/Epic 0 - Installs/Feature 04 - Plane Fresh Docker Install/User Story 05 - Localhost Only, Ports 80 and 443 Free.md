# User Story 05 — Localhost Only, Ports 80 and 443 Free

**Status:** Done 2026-11-06

**Story:** As the CRO developer, I want Plane published on 127.0.0.1:8090 only, so nothing on the LAN can reach it and ports 80 and 443 stay free for future projects.

**Done when:** docker ps shows only 127.0.0.1:8090 published for Plane, and ports 80 and 443 are not bound.

**Notes:** Only the proxy publishes a port: 127.0.0.1:8090->80. No listener on 80 or 443. All other published ports in the CRO stack are also on 127.0.0.1.
