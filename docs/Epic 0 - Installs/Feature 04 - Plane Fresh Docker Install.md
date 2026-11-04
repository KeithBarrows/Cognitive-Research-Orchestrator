# Feature 04 — Plane Fresh Docker Install

*(Part of Epic 0 — Installs. See `../phase-0-plan.md` for the full
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
