# Phase 0 Plan — Installs

**Status:** Named 2026-11-04, in response to a real gap — Phase 1's
plan assumed OB1 local and a dedicated Postgres existed, but neither
install was ever written down as its own step. See
`docs/phase-roadmap.md` for how this fits with Phases 1–5.

## 1. Scope

Stand up every piece of software Phase 1's bootstrap code will run
against, on the laptop (per `CURRENT.md`'s non-negotiables — CRO runs
and is coded on the laptop only). No CRO code gets written in this
phase; this is infrastructure only.

## 2. Installs

- **Docker Desktop** — confirm it's already installed and running on
  the laptop; install it if not. Everything else in this phase runs
  inside it.
- **Postgres with the pgvector extension** — a container **dedicated
  to `cro_index`**, not shared with anything else. This matters
  specifically because the *old* local OB1 instance failed partly
  because it shared its Postgres with an unrelated weather-station
  project (see `CURRENT.md`'s OB1 status note) — this is the same
  mistake, not repeated. Also satisfies the already-settled decision
  that `cro_index` storage stays separate from OB1-owned storage.
- **OB1, fresh Docker install** — the real blocker flagged when Phase
  1 was reviewed: the exact Docker image/compose setup and the local
  instance's actual REST API surface are both unverified. This phase
  is where that gets resolved — install it, then confirm live what its
  REST endpoints actually look like, the same way TheBrain's and
  Plane's were confirmed live before being written into the schema.
  Not reusing the existing `ob1-local` Supabase instance — fresh
  install, per the existing Phase 1 note.
- **Plane, fresh Docker install** — moved here from Phase 2's
  description, since it's an install step, not a Lookup-phase feature.
  One project named "CRO." Phase 2 is still where the 2-3 hand-added
  Work Items and the actual Lookup capability happen — this phase
  just gets Plane running and reachable.
- **TheBrain — no install, a manual file sync instead.** TheBrain
  itself isn't going into Docker; its brains live on disk as local
  files. Getting the same brains onto the laptop is a manual
  BeyondCompare sync of those files from wherever they currently live,
  not an API-driven migration. (TheBrain's Local API — the thing
  Phase 1's bootstrap actually reads from — talks to whichever brain
  files are present on that machine; this step is what makes sure the
  real brains are actually there to read.)
- **New MCP server connections, pointed at the new local instances —
  added 2026-11-04.** Confirmed live during Phase 1 planning: the
  Plane and Postgres/Supabase MCP tools already available in this
  session are both pointed at the *wrong* targets — Plane at the
  existing writing/CreativeOS workspace, Postgres at OB1's cloud
  Supabase project (93 `thoughts` rows, plus unrelated
  `life_engine_*` tables). Neither follows this phase's new installs
  automatically. **New connections, served from the laptop only**
  (same non-negotiable as everything else — never the desktop), need
  to be configured against the new local Postgres+pgvector container
  and the new local Plane instance before any of the AI-directed
  testing below can run against the right database.
- **A local DNS resolver, in Docker, on the laptop — added
  2026-11-04, resolves `CURRENT.md`'s hostname open question,
  corrected 2026-11-04.** dnsmasq (or Pi-hole, which uses dnsmasq
  underneath — but Pi-hole's own local-DNS UI doesn't support
  wildcards, so use dnsmasq directly if a wildcard is ever wanted)
  holding local override records that resolve subdomains of
  `sol3.net` — the user's long-term **personal** domain, not
  `quantumfracturecreative.com` (that one's for the writing/business
  side; CRO is personal infrastructure) — e.g. `cro.home.sol3.net` —
  to the laptop's own LAN IP, for every device on the home network —
  not a per-machine `hosts`-file edit, which doesn't scale once more
  subdomains exist. Chosen over `.home.arpa` or a made-up TLD (`.lan`,
  `.home`) because a real owned-domain subdomain can get genuine,
  browser-trusted HTTPS certificates later via a DNS-01 challenge; the
  other two can't, or risk leaking lookups to the public DNS root.
  Future web sites get the same subdomain treatment. **Resolved
  2026-11-04: every device on the LAN, not just the desktop and
  laptop** — set via the router's DHCP DNS setting, so any new device
  that joins the network picks it up automatically, not a per-device
  setup chore. This means dnsmasq must also forward every non-local
  query (ordinary internet domains) to a real upstream DNS (e.g.
  1.1.1.1 or 8.8.8.8) — it becomes the network's primary resolver for
  everything, not just these subdomains, so normal browsing can't
  break for every other device on the network.

## 2b. Why this matters for testing (added 2026-11-04)

With CRO's own C# code not written yet, Phase 0/1 can still be
verified directly — creating the `cro_index` schema, inserting test
rows, confirming pgvector actually works, creating Plane's "CRO"
project and its first Work Items, checking round-trips — all through
MCP tools once they're pointed at the right, newly-installed local
instances. This is AI-directed infrastructure testing, not a
replacement for testing CRO's actual application logic once that
code exists.

## 3. Not yet designed

- The exact OB1 Docker image/compose file to use, and its real REST
  API shape once running — genuinely unknown until this phase
  actually happens.
- Whether the BeyondCompare TheBrain sync is a one-time copy or needs
  to stay a repeatable step (e.g. if the desktop's brains keep
  changing before the laptop becomes the sole working copy).
- Whether devices get pointed at the new DNS resolver via the router's
  DHCP DNS setting (every device, automatically) or configured
  individually (just the desktop and laptop, for now) — not decided.

## 4. Exclusions

No CRO code. No bootstrap run (that's Phase 1, and it depends on this
phase being done first). No Plane project configuration beyond
getting it running (Work Items are Phase 2).
