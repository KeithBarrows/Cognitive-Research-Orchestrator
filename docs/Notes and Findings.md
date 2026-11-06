# Notes and Findings

Keith's own findings, kept so they are not lost. These are NOT part of
any plan yet. Nothing here is decided. When a finding becomes real work,
move it into a Feature or User Story and leave a link here.

Format: newest first. Each entry has a date, a source, and a status
(Unverified / Verified / Planned).

## 2026-11-06 — CRO needs an in-depth health check and a health API endpoint

**Source:** Keith, after the first full reboot check.
**Status:** Unverified (nothing built yet; this is a need, not a plan).

CRO's future code base needs an in-depth health check, and an API
endpoint that exposes it. The check should cover every system CRO
depends on, not just "is the process up":

- Docker: each container running and healthy, restart counts, exit
  codes, disk use.
- `cro_index` Postgres: reachable, Flyway at the expected version,
  tables present, row counts sane.
- OB1 (Supabase stack + Ollama): API answers, database answers, the
  embedding model is loaded and returns a vector.
- Plane: API answers, workspace `cro` and project `CRO` exist.
- TheBrain: Local API answers with the token, all expected brains are
  listed, each home Thought is readable.

**Why it matters later:** after a reboot, a manual walk through Docker
and TheBrain took many separate commands. One endpoint (for example
`GET /health/deep`, next to the ping-only scaffold) could answer it in
one call and name exactly which part is down.

**Lessons from the first reboot check (2026-11-06):**

- Several containers restart a few times at boot (`supabase-auth` 10,
  `supabase-storage` 10, `supabase-pooler` 6, `realtime` 4, Plane api
  and workers 2). The logs show they tried to reach Postgres while it
  was still "starting up", then recovered. The check should tell
  "restarted at boot, now healthy" from "crash looping".
- A running container is not a healthy service. Check the real API and
  database behind each one.
- Keep a shallow check (fast, no secrets, for "is it alive") separate
  from the deep check (uses tokens, touches every system).

**To decide when the time comes:** whether the deep endpoint needs its
own auth; how long a deep check may take; whether results are cached.

## 2026-11-06 — TheBrain thoughts are tied to real folders

**Source:** Keith.
**Status:** Unverified (not yet checked against the TheBrain API).

Each TheBrain thought is married to a physical folder on the hard
drive. When saving links, files, images or videos and attaching them to
an existing thought, the TheBrain API should be able to return that
thought's physical folder path. Then CRO can save the file straight into
the correct folder, instead of guessing or asking.

**Why it matters later:** the capture flow ("please remember [link]")
could file attachments in the right place on its own.

**To check when the time comes:** which API call returns the folder
path; whether it works for thoughts that have no folder yet; whether
the path is the same one the file sync (Feature 05) sees.
