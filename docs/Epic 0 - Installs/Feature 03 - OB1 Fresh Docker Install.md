# Feature 03 — OB1 Fresh Docker Install

*(Part of Epic 0 — Installs. See `../phase-0-plan.md` for the full
Epic.)*

## Install

OB1, fresh Docker install — the real blocker flagged when Epic 1 was
first reviewed: the exact Docker image/compose setup and the local
instance's actual REST API surface are both unverified. This is where
that gets resolved. **Not reusing** the existing `ob1-local` Supabase
instance — it's not reusable as-is (crashed Edge Runtime, shared
Postgres with the weather-station project — see `../../CURRENT.md`'s
OB1 status note); this is a fresh install, not a repair.

## Test

- Install it, then confirm live what its REST endpoints actually
  look like — the same way TheBrain's and Plane's were confirmed
  live before being written into the schema. This is genuinely
  unknown until this Feature actually happens.
- The local OB1 Docker container is running and reachable.
- Confirm it uses its **own** Postgres, not shared with `cro_index`
  (Feature 02) or anything else.

## Not yet designed

- The exact OB1 Docker image/compose file to use — genuinely unknown
  until this Feature actually runs.
- Its real REST API shape once running — the cloud instance exposes
  `list_thoughts`/`search_thoughts`/`capture_thought` via MCP; the
  local one may differ, and CRO talks to it over REST, not MCP (see
  `../README.md`'s architecture: OB1 is reached over its own REST API,
  not a second MCP hop).
