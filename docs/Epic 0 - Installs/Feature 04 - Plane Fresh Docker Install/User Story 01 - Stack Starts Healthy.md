# User Story 01 — Stack Starts Healthy

**Status:** Done 2026-11-06

**Story:** As the CRO developer, I want the Plane stack to start from one compose file, so I can bring it up with up.cmd.

**Done when:** All services are running (migrator exited 0) and http://localhost:8090 answers.

**Notes:** All 13 services up, migrator exited 0, http://localhost:8090 returns 200 and /api/instances/ answers. First start is slow (about 5 minutes): the migrator applies about 100 Django migrations onto the D-drive bind mount and the api waits for it (502 until then). Problems found: (1) the proxy crash-looped because CERT_ACME_CA was empty (Caddyfile breaks); fixed by keeping upstream's Let's Encrypt URL in plane.env (unused on plain HTTP). (2) up.cmd first set Plane's generic variable names (POSTGRES_PASSWORD, SECRET_KEY) for the whole session, which overrode the OB1 Supabase stack's own values and recreated its containers with the wrong password; fixed by setting Plane's variables inside setlocal/endlocal, last in up.cmd. OB1 then came back healthy.
