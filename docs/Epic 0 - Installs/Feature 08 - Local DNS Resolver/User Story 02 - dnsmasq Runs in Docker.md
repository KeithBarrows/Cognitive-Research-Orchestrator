# User Story 02 — dnsmasq Runs in Docker

**Status:** Not started

**Story:** As the CRO developer, I want dnsmasq running in Docker on the laptop, so the home network has a local resolver.

**Done when:** `src/Infra/08-dns` starts dnsmasq, which forwards other names to 1.1.1.1 with 9.9.9.9 as fallback, and `up.cmd` has one more line.

**Notes:** Exception to "localhost only": DNS must listen on the laptop's LAN IP, port 53 only (home network only, per the 2026-10-17 decision). Record the exception in `DECISIONS.md`. Check that nothing on Windows already uses port 53.
