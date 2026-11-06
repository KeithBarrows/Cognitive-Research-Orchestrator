# User Story 04 — Data Stored on D Drive

**Status:** Done 2026-11-05

**Story:** As the CRO developer, I want OB1's database and the Ollama
models on `D:\Data\CRO`, so they survive deleting containers.

**Done when:** Files appear in `D:\Data\CRO\ob1-db` and
`D:\Data\CRO\ollama` after start.

**Notes:** Both are bind mounts set in our `docker-compose.yml`.
`ob1-db` has 24 entries and `ollama` 3 (verified). The Deno module
cache stays a named Docker volume on purpose: it is disposable and
costs one small re-download if lost.
