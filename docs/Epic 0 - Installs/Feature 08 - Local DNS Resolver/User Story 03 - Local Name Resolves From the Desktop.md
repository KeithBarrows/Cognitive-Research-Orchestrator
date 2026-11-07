# User Story 03 — Local Name Resolves From the Desktop

**Status:** Done

**Story:** As the CRO developer, I want `cro.home.sol3.net` to resolve to the laptop from the desktop, so the name works on the home network.

**Done when:** From the desktop, a lookup of `cro.home.sol3.net` returns the laptop's reserved LAN IP.

**Notes:** The domain is sol3.net (personal), not quantumfracturecreative.com.
Done 2026-11-06 through a hosts-file line, not DNS.
`ping cro.home.sol3.net` returns `192.168.9.250`.
