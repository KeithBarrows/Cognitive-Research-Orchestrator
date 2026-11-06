# User Story 04 — Own Postgres Not Shared

**Status:** Done 2026-11-06

**Story:** As the CRO developer, I want Plane to use its own Postgres, so it never shares a database with cro_index or OB1.

**Done when:** Plane's plane-db is a separate container and data folder from cro-index-db and the OB1 db.

**Notes:** plane-db is its own container (postgres:15.7-alpine) with its own data folder, separate from cro-index-db (pgvector pg17) and supabase-db. No Plane port is published for the database.
