# Feature 08 — Local DNS Resolver

*(Part of Epic 0 — Installs. See `../phase-0-plan.md` for the full
Epic.)*

## Install

A local DNS resolver, in Docker, on the laptop — resolves
`../../CURRENT.md`'s hostname non-negotiable. dnsmasq (or Pi-hole,
which uses dnsmasq underneath — but Pi-hole's own local-DNS UI
doesn't support wildcards, so use dnsmasq directly if a wildcard is
ever wanted), holding local override records that resolve subdomains
of `sol3.net` — the user's long-term **personal** domain, not
`quantumfracturecreative.com` (that one's for the writing/business
side; CRO is personal infrastructure) — e.g. `cro.home.sol3.net` — to
the laptop's own LAN IP, for **every device on the home network**, set
via the Gryphon router's DHCP DNS setting.

**Upstream chosen:** Cloudflare `1.1.1.1` primary, Quad9 `9.9.9.9`
secondary/fallback — 1.1.1.1 is the fastest of the major public
resolvers with the cleanest privacy stance; 9.9.9.9 is kept for its
built-in blocking of known-malicious domains. dnsmasq must forward
every non-local query to these — it becomes the network's primary
resolver for everything, not just these subdomains, so normal
browsing can't break for every other device on the network.

**Router note:** the Gryphon router currently hands out the ISP's own
DNS via its internal DHCP — that gets replaced by the laptop's
dnsmasq address once it exists, not pointed at `1.1.1.1`/`9.9.9.9`
directly (those are dnsmasq's own upstreams, one layer further in).

## Test

- `cro.home.sol3.net` resolves to the laptop's LAN IP from another
  device on the home network (the desktop, specifically).
- An ordinary internet domain (e.g. a normal website) still resolves
  correctly through the resolver — proving the upstream-forwarding
  half works, not just the local override.
- The router's DHCP hands out the resolver's address, not the ISP's,
  to a freshly-joined device.

## Not yet designed

See Feature 09 — the travel-access naming scheme is a separate,
related Feature, not folded into this one.
