# Feature 04 — Plane Fresh Docker Install

*(Part of Epic 0 — Installs. See `../../phase-0-plan.md` for the full
Epic.)*

## Install

Plane, fresh Docker install — a blank, self-hosted Community Edition
install, not the existing cloud Plane workspace already connected to
this session (confirmed live to belong to the writing/CreativeOS
projects instead: Author Operations, JT Kaelen, Infrastructure,
Quantum Fracture Press — no CRO project there). One project named
"CRO" gets created inside it.

## Test

- The fresh Plane instance is running and reachable.
- A project named "CRO" can be created in it.
- Plane's self-hosted stack brings its **own** bundled Postgres
  (plus Redis, MinIO, etc. per its own Compose file) — confirm it is
  not sharing a database with `cro_index` (Feature 02) or OB1
  (Feature 03).

## Not yet designed

- The 2-3 hand-added Work Items and the actual indexing of them into
  `cro_index` are **Epic 2's** job, not this Feature's — this Feature
  just gets Plane running and reachable with an empty "CRO" project.

## Result

**Done 2026-11-06.** All 9 User Stories in this folder are done.
Setup lives in `src\Infra\04-plane` (upstream `makeplane/plane` v1.4.3
compose, kept unmodified in `docker-compose.upstream.yml`, with our
changes in `docker-compose.yml` and `plane.env`, listed in
`UPSTREAM.txt`), started by `src\Infra\up.cmd`. Data is in
`D:\Data\CRO\plane`. Only `127.0.0.1:8090` is published; ports 80 and
443 stay reserved. Secrets are User Secrets keys `Plane:*`, including
`Plane:ApiToken`. Workspace slug `cro`, project `CRO`, no work items
yet. First start takes about 5 minutes (schema migrations on the D
drive); later starts take about 1 minute.
