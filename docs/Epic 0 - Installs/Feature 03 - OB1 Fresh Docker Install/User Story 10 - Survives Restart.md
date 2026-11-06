# User Story 10 — Survives Restart

**Status:** Done 2026-11-05

**Story:** As the CRO developer, I want OB1's thoughts and models to
survive a restart, so a reboot does not wipe the brain.

**Done when:** After `docker compose down` (no `-v`) and `up`, a
captured thought is still found by search, and the model does not need
pulling again.

**Notes:** A thought survived `down` (no `-v`) and `up`. The init
scripts did not re-run (they run only on an empty database folder),
the model needed no re-pull, and the Deno cache persisted. The first
search after the restart took about 2.5 s versus about 0.3 s warm.
Data is on bind mounts under `D:\Data\CRO`.
