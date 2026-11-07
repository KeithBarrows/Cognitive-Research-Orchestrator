# User Story 01 — cro.localhost Works Offline

**Status:** Done

**Story:** As the CRO developer, I want `cro.localhost` to reach CRO with no network, so traveling needs no DNS at all.

**Done when:** `cro.localhost` resolves to `127.0.0.1` in .NET, a browser and curl, with Wi-Fi off.

**Notes:** Option 1 from the Feature file. Can be done now at home.

2026-11-06, tested on the laptop (Plane at `127.0.0.1:8090`):
- curl: `http://cro.localhost:8090/api/instances/` returned HTTP 200
  from `127.0.0.1`. Passed.
- .NET: Keith states it works. Not tested here.
- `ping cro.localhost` and .NET `Dns.GetHostAddresses` do not resolve
  it on Windows. Browsers and curl resolve `*.localhost` themselves.
- Browser: Keith reports `http://cro.localhost:8090` loads Plane
  (2026-11-06). Whether Wi-Fi was off for this check was not stated.
- curl with Wi-Fi off: Keith reports it works (2026-11-06).
- These last two results are Keith's reports, not run by Claude.
