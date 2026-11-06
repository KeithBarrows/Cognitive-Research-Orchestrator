# User Story 02 — Compose File Parses

**Status:** Done 2026-11-05

**Story:** As the CRO developer, I want the combined compose file to
load without errors, so I find setup problems before starting
containers.

**Done when:** `docker compose config --quiet` prints no errors.

**Notes:** Passed on the unmodified recipe and again after our edits.
The merged config shows our data paths replaced Supabase's defaults
(no `volumes/db/data` or `ollama_data` left). Use `--quiet`: plain
`config` prints the secrets.
