# User Story 01 — Postgres Container Runs

**Status:** Done 2026-11-05

**Story:** As the CRO developer, I want a Postgres container with
pgvector that only cro_index uses, so nothing else can break it.

**Done when:** `docker compose up -d` in
`src\Infra\02-cro-index-postgres` gives a container that reports
healthy.

**Notes:** Image `pgvector/pgvector:pg17`, host port
`127.0.0.1:5433`.
