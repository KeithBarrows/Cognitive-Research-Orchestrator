# User Story 02 — Local API Lists All 8 Brains

**Status:** Done 2026-11-06

**Story:** As the CRO developer, I want TheBrain's Local API to list every brain, so Epic 1's bootstrap can find them.

**Done when:** A call to `/brains` on the laptop's Local API returns all 8 brains.

**Notes:** The Local API answers on http://localhost:11522 with an Authorization: Bearer header. GET /api/brains returned HTTP 200 and all 8 brains: Lifestyle Defined, Growth, CRO API Discovery 2026-10-11, Future Life, SW Architecture, Blue Skies Unlimited, Filing Cabinet and MVP 2013, each with its id and homeThoughtId. The TheBrain 15 desktop app was running on the laptop at the time; whether the API works with the app closed is not tested. The API token must go in User Secrets (suggested key TheBrain:ApiToken), never in the repo. Keith pasted it into the chat on 2026-11-06, so consider regenerating it later.

TheBrain 15 has a setting, "Start hidden when you log in", which Keith turned on 2026-11-06. TheBrain then runs hidden after login, so the Local API on port 11522 is up whenever the laptop is logged in. The API is not reachable before login or with TheBrain fully quit. Not yet tested across a real log-out and log-in.
