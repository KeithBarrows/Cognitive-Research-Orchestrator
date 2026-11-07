# User Story 03 — Test for DNS Rebinding Blocks

**Status:** Later

**Story:** As the CRO developer, I want both options tried on at least two foreign networks, so I know which one survives DNS-rebinding protection.

**Done when:** Each option is tested on two or more networks other than home, with the results and the networks written here.

**Notes:** Needs travel. Some routers and resolvers block a public name that points at a loopback or private address, which is exactly what option 2 does.
2026-11-06: only `cro.localhost` is left to test. It uses no DNS, so
rebinding blocks should not apply. Confirm in a browser on one
foreign network.
