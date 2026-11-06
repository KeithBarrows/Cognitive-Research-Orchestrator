# Feature 05 — TheBrain File Sync

*(Part of Epic 0 — Installs. See `../../phase-0-plan.md` for the full
Epic.)*

## Install

Not a Docker install. TheBrain's brains live on disk as local files
— getting the same brains onto the laptop is a manual BeyondCompare
sync of those files from wherever they currently live, not an
API-driven migration. TheBrain's Local API — the thing Epic 1's
bootstrap actually reads from — talks to whichever brain files are
present on the machine it runs on; this Feature is what makes sure
the real brains are actually there to read.

## Test

- All 8 real brains (Growth, Filing Cabinet, Future Life,
  SW Architecture, MVP 2013, Lifestyle Defined, Blue Skies Unlimited,
  CRO API Discovery 2026-10-11) are present on the laptop.
- TheBrain's Local API, running on the laptop, can list all 8 brains
  via `/brains` and resolve at least one real Thought from each —
  confirming the sync actually brought over working brain files, not
  just copied bytes.

## Not yet designed

- Whether this sync is a one-time copy or needs to stay a repeatable
  step (e.g. if the desktop's brains keep changing before the laptop
  becomes the sole working copy).

## Result

**Done 2026-11-06** for Epic 0's purpose: Stories 01 to 03 are done and
Story 04 (one-time or repeatable sync) is marked Later. All 8 brains
are in `D:\Data\Brains\U01` (the live TheBrain 15 store). The Local API
answers on `http://localhost:11522` with a Bearer token, `GET
/api/brains` lists all 8 brains, and each brain's home Thought was read
by `GET /api/thoughts/{brainId}/{thoughtId}`. The token belongs in User
Secrets (suggested key `TheBrain:ApiToken`), not in the repo.
