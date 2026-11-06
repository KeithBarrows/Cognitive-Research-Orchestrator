# User Story 03 — Secrets From User Secrets

**Status:** Done 2026-11-06

**Story:** As the CRO developer, I want Plane's passwords and keys to come from User Secrets, so no upstream default (plane/plane) is in use.

**Done when:** up.cmd sets the Plane:* secrets, the running containers do not use the defaults, and nothing secret is in the repo.

**Notes:** Six Plane:* secrets generated (openssl rand -hex 24) and stored in User Secrets. Inside the running api container SECRET_KEY, DATABASE_URL, AMQP_URL and the MinIO key are not the upstream defaults (change-this-key, plane:plane, access-key). Nothing secret is in the repo; plane.env holds only non-secret settings.
