# User Story 08 — Own Postgres, Not Shared

**Status:** Done 2026-11-05

**Story:** As the CRO developer, I want OB1 to use its own Postgres,
so it never shares a database with `cro_index`.

**Done when:** `docker ps` shows `supabase-db` and `cro-index-db` as
separate containers with separate data folders and host ports.

**Notes:** `supabase-db` uses image `supabase/postgres:17.6.1.136`.
The pooler uses host ports 5432 and 6543; `cro-index-db` stays on
5433, so there is no clash. Separate data folders (`ob1-db` and
`cro-index-postgres`) confirmed.
