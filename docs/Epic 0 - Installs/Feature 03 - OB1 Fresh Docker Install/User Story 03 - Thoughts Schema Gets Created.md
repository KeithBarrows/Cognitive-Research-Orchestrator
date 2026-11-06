# User Story 03 — Thoughts Schema Gets Created

**Status:** Done 2026-11-05

**Story:** As the CRO developer, I want the `thoughts` table and its
search functions created at the chosen embedding size, so capture and
search have somewhere to work.

**Done when:** `thoughts`, `match_thoughts` and `upsert_thought` exist
and the embedding column is `vector(768)`.

**Notes:** Three upstream problems found 2026-11-05: (1) Supabase's
`db` service never mounts `volumes/db/init`, and its `migrate.sh`
runs only `.sql` files from `init-scripts\`, so our `.sh` scripts were
ignored there; (2) `EMBED_DIM` never reached the `db` container; (3)
the upstream `.sh` files arrive with CRLF line endings (the OB1 clone
checks out CRLF, `core.autocrlf=true`), which breaks bash inside the
Linux container. Fix, in our `docker-compose.yml` only: mount the
scripts at the top level as `zz-01-...` and `zz-02-...` (the standard
entrypoint runs them after Supabase's own setup) and pass
`EMBED_DIM`. Our two copies were converted to LF in place;
`.gitattributes` keeps `*.sh` LF. Verified on a fresh empty `ob1-db`:
the log shows both scripts, `thoughts` is `vector(768)`, both
functions exist.

Lessons: Git Bash `grep` hides `\r` (count with `tr -cd '\r' | wc
-c`); `docker exec -i < file` from Windows inserts CRLF; set
`MSYS_NO_PATHCONV=1` for container paths.
