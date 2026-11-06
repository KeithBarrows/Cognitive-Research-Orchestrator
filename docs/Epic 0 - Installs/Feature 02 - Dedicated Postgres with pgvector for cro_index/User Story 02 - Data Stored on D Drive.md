# User Story 02 — Data Stored on D Drive

**Status:** Done 2026-11-05

**Story:** As the CRO developer, I want the database files on
`D:\Data\CRO`, so the data survives deleting the container.

**Done when:** Files appear in `D:\Data\CRO\cro-index-postgres` after
start.

**Notes:** Bind mount, not a named volume. 23 files seen, no
permission errors. Resetting means wiping that folder (the password is
set at first start).
