# User Story 01 — Recipe Copied and Keys Generated

**Status:** Done 2026-11-05

**Story:** As the CRO developer, I want the upstream local-brain
recipe in our own setup folder with fresh keys, so OB1 runs locally
with no cloud account.

**Done when:** `src\Infra\03a-ob1-local-brain\` holds the recipe, and
`setup.sh` has cloned Supabase and written a gitignored `.env`.

**Notes:** Recipe copied unmodified from
`D:\Repos\KeithBarrows\OB1\recipes\local-brain-no-mcp` at commit
`238df6c` (see `UPSTREAM.txt`). `setup.sh` needs a real `python3`;
Windows only had a Store stub, so Python 3.13.17 was installed with
winget and a temporary `python3` wrapper was used for that one run.
`supabase-docker/` is in `.gitignore` (the keys live in its `.env`).
Generated secrets are a recorded exception to the User Secrets rule:
Supabase reads about 10 of them through `env_file`.
