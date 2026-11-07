# User Story 03 — Write Brains and Types to cro_index

**Status:** Not started

**Story:** As the CRO developer, I want the lists written to `brains` and `thebrain_types`, so Feature 02 has real rows for its foreign keys.

**Done when:** `brains` has one row per brain in the live list, and `thebrain_types`
has one row per live Type. A second run makes no duplicates (update or
insert, not blind insert). Every row has `last_synced_at` set to the run
time.
