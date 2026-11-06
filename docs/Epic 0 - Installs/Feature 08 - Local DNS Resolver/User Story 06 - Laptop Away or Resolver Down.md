# User Story 06 — Laptop Away or Resolver Down

**Status:** Not started

**Story:** As the CRO developer, I want the home network to keep working when the laptop is off or away, so nobody loses the internet.

**Done when:** The behavior is tested and written here: what devices do when the resolver does not answer, and the fallback chosen.

**Notes:** Gap found 2026-11-05. If the router lists a second DNS server, devices may use it and skip the local name; if it lists none, the house loses DNS when the laptop leaves. Needs a decision before Story 05 goes live.
