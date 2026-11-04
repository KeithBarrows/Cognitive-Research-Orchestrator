# Feature 09 — Travel-Access Naming

*(Part of Epic 0 — Installs. See `../phase-0-plan.md` for the full
Epic.)*

## Install

Test **both** real candidates for reaching CRO while traveling
(laptop-only, no other device involved — see `../../CURRENT.md`),
commit to one — decided 2026-11-04:

1. **Two names, zero infrastructure:** `cro.home.sol3.net` at home
   (Feature 08's dnsmasq override → the laptop's LAN IP) and plain
   `cro.localhost` while traveling — reserved by RFC 6761 to always
   resolve to `127.0.0.1`, confirmed implemented in .NET itself (the
   runtime CRO is built on), no DNS record, no config, works offline.
2. **One name everywhere:** a real, public wildcard DNS record,
   `*.home.sol3.net` → `127.0.0.1`, published through sol3.net's real
   DNS provider. Split-horizon: the home dnsmasq override wins at
   home; the public record answers everywhere else.

## Test

**Caveat to test for specifically:** some routers and DNS resolvers
enable **DNS rebinding protection**, which deliberately blocks any
response pointing a public-looking domain name at a private/loopback
address — exactly the pattern option 2 creates. Test both options on
more than one real foreign network (not just one hotel/cafe Wi-Fi) —
whether option 2 gets blocked depends on which resolver that network
uses, not something to assume from a single test.

## Not yet designed

Which approach actually works — genuinely unknown until tested
against real networks.
