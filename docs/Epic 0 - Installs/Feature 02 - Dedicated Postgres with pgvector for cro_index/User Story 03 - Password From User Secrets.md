# User Story 03 — Password From User Secrets

**Status:** Done 2026-11-05

**Story:** As the CRO developer, I want the DB password in .NET User
Secrets, so no password file sits in the repo.

**Done when:** `src\Infra\up.cmd` reads `CRO:DbPassword` (from
`src\CRO`) and the container starts with it.

**Notes:** The password is set for that cmd session only. Compose
cannot read User Secrets itself, so `up.cmd` bridges it.
