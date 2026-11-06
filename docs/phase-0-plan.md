# Epic — Installs

*(Formerly "Phase 0." File name stays `phase-0-plan.md` for stable
history — see `docs/phase-roadmap.md` for the full Epic list.)*

**Status:** Named 2026-11-04, in response to a real gap — Epic 1's
plan assumed OB1 local and a dedicated Postgres existed, but neither
install was ever written down as its own step. See
`docs/phase-roadmap.md` for how this fits with the other Epics.

## 1. Scope

Stand up every piece of software Epic 1's bootstrap code will run
against, on the laptop (per `CURRENT.md`'s non-negotiables — CRO runs
and is coded on the laptop only). No CRO code gets written in this
phase; this is infrastructure only.

**The actual workflow is install → test → commit to a final setup,
not just install (clarified 2026-11-04).** Several items below have
more than one real candidate (the Postgres MCP, the travel-access
naming scheme) — Epic 0's job is to actually try each one, since
it's all disposable Docker and cheap to throw away what doesn't work,
then write down which one won as the real, final setup. Don't decide
those on paper alone.

## 2. Installs

**Each item below now has its own Feature file** in
`Epic 0 - Installs/` (added 2026-11-04), following the Plane
EPIC/FEATURE/USER STORY convention in `docs/phase-roadmap.md`. This
section stays as the Epic-level summary; the Feature files carry the
install/test detail.

- **Docker Desktop** — confirm it's already installed and running on
  the laptop; install it if not. Everything else in this phase runs
  inside it. (`Epic 0 - Installs/Feature 01 - Docker Desktop.md`)
- **Postgres with the pgvector extension** — a container **dedicated
  to `cro_index`**, not shared with anything else. This matters
  specifically because the *old* local OB1 instance failed partly
  because it shared its Postgres with an unrelated weather-station
  project (see `CURRENT.md`'s OB1 status note) — this is the same
  mistake, not repeated. Also satisfies the already-settled decision
  that `cro_index` storage stays separate from OB1-owned storage.
- **OB1, fresh Docker install** — the real blocker flagged when Epic
  1 was reviewed: the exact Docker image/compose setup and the local
  instance's actual REST API surface are both unverified. This phase
  is where that gets resolved — install it, then confirm live what its
  REST endpoints actually look like, the same way TheBrain's and
  Plane's were confirmed live before being written into the schema.
  Not reusing the existing `ob1-local` Supabase instance — fresh
  install, per the existing Epic 1 note.
- **Plane, fresh Docker install** — moved here from Epic 2's
  description, since it's an install step, not a Lookup-phase feature.
  One project named "CRO." Epic 2 is still where the 2-3 hand-added
  Work Items and the actual Lookup capability happen — this phase
  just gets Plane running and reachable.
- **TheBrain — no install, a manual file sync instead.** TheBrain
  itself isn't going into Docker; its brains live on disk as local
  files. Getting the same brains onto the laptop is a manual
  BeyondCompare sync of those files from wherever they currently live,
  not an API-driven migration. (TheBrain's Local API — the thing
  Epic 1's bootstrap actually reads from — talks to whichever brain
  files are present on that machine; this step is what makes sure the
  real brains are actually there to read.)
- **New MCP server connections, pointed at the new local instances —
  added 2026-11-04.** Confirmed live during Epic 1 planning: the
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
- **`cro_index`'s Postgres MCP: trial both real candidates, keep
  whichever works — decided 2026-11-04.** The Supabase MCP tools
  won't talk to a plain Postgres+pgvector container (they're built
  against Supabase's own API layer, confirmed not generic). Two real,
  current options take a plain connection string instead:
  `mcp-server-pgvector` (pgvector-specific: similarity search, hybrid
  vector+full-text, upserts, index management) and `postgres-mcp`
  (broader: schema introspection, migration tracking, pgvector among
  other extensions). Neither has been live-tested yet — can't be,
  until `cro_index`'s Postgres container exists. Since this is all
  disposable Docker, run both as separate containers against the same
  `cro_index` database, confirm which actually works end-to-end
  (schema creation, inserts, vector similarity queries), and kill
  whichever doesn't — no need to commit to one on paper first.
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
  query (ordinary internet domains) to a real upstream DNS — it
  becomes the network's primary resolver for everything, not just
  these subdomains, so normal browsing can't break for every other
  device on the network. **Upstream chosen, 2026-11-04: Cloudflare
  `1.1.1.1` primary, Quad9 `9.9.9.9` secondary/fallback.** 1.1.1.1 is
  the fastest of the major public resolvers (~11ms median) with the
  cleanest privacy stance among them (no IP logging, query data
  purged within 24 hours, independently audited); 9.9.9.9 is kept as
  a fallback for its built-in blocking of known-malicious domains,
  reasonable given this network also carries CRO's own sensitive
  infrastructure traffic, not just casual browsing. dnsmasq supports
  multiple upstreams, so this isn't an either/or.
  Router note: the Gryphon router currently hands out the ISP's own
  DNS via its internal DHCP — that gets replaced by the laptop's
  dnsmasq address once it exists, not pointed at 1.1.1.1/9.9.9.9
  directly (those are dnsmasq's own upstreams, one layer further in).
- **Travel-access naming: test both real candidates, commit to one —
  added 2026-11-04.** Two approaches exist for reaching CRO while
  traveling (laptop-only, no other device involved — see
  `CURRENT.md`), neither live-tested yet:
  1. **Two names, zero infrastructure:** `cro.home.sol3.net` at home
     (the dnsmasq override above, → the laptop's LAN IP) and plain
     `cro.localhost` while traveling — reserved by RFC 6761 to always
     resolve to `127.0.0.1`, confirmed implemented in .NET itself (the
     runtime CRO is built on), no DNS record, no config, works
     offline.
  2. **One name everywhere:** a real, public wildcard DNS record,
     `*.home.sol3.net` → `127.0.0.1`, published through sol3.net's
     real DNS provider. Split-horizon: the home dnsmasq override wins
     at home; the public record answers everywhere else. Costs one
     more DNS record to publish and maintain.
  **Caveat that could break option 2 on some networks, not seen until
  just now:** some routers and DNS resolvers enable **DNS rebinding
  protection**, which deliberately blocks any response pointing a
  public-looking domain name at a private/loopback address — exactly
  the pattern `*.home.sol3.net → 127.0.0.1` creates. Whether this
  actually blocks it depends on which resolver a given foreign
  network uses; not something to assume works until tested on a few
  different networks. Test both approaches for real, on more than one
  network if possible, and commit to whichever actually works as this
  phase's final setup — don't decide on paper only.

**Feature file mapping** (`Epic 0 - Installs/`, added 2026-11-04):

| Install item above | Feature file |
|---|---|
| Docker Desktop | `Feature 01 - Docker Desktop.md` |
| Postgres + pgvector, dedicated to `cro_index` | `Feature 02 - Dedicated Postgres with pgvector for cro_index/Feature 02 - Dedicated Postgres with pgvector for cro_index.md` (plus a `User Story NN` file per step, in the same folder) |
| OB1, fresh Docker install | `Feature 03 - OB1 Fresh Docker Install/Feature 03 - OB1 Fresh Docker Install.md` (plus a `User Story NN` file per step, in the same folder) |
| Plane, fresh Docker install | `Feature 04 - Plane Fresh Docker Install/Feature 04 - Plane Fresh Docker Install.md` (plus a `User Story NN` file per step, in the same folder) |
| TheBrain file sync | `Feature 05 - TheBrain File Sync.md` |
| New Plane MCP connection | `Feature 06 - Plane MCP Connection.md` |
| `cro_index` Postgres MCP (trial both) | `Feature 07 - cro_index Postgres MCP Connection.md` |
| Local DNS resolver | `Feature 08 - Local DNS Resolver.md` |
| Travel-access naming | `Feature 09 - Travel-Access Naming.md` |

## 2b. Why this matters for testing (added 2026-11-04)

With CRO's own C# code not written yet, Epic 0/1 can still be
verified directly — creating the `cro_index` schema, inserting test
rows, confirming pgvector actually works, creating Plane's "CRO"
project and its first Work Items, checking round-trips — all through
MCP tools once they're pointed at the right, newly-installed local
instances. This is AI-directed infrastructure testing, not a
replacement for testing CRO's actual application logic once that
code exists.

## 3. Not yet designed

- The exact OB1 Docker image/compose file to use, and its real REST
  API shape once running — candidates found 2026-11-05, to be tried
  and chosen in this Epic; see `Epic 0 - Installs/Feature 03 - OB1
  Fresh Docker Install.md`.
- Whether the BeyondCompare TheBrain sync is a one-time copy or needs
  to stay a repeatable step (e.g. if the desktop's brains keep
  changing before the laptop becomes the sole working copy).
- Which of the two travel-access naming approaches actually works —
  genuinely unknown until tested against real networks (see above).

## 4. Exclusions

No CRO code. No bootstrap run (that's Epic 1, and it depends on this
phase being done first). No Plane project configuration beyond
getting it running (Work Items are Epic 2).
