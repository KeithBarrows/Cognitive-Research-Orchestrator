# User Story 07 — Resync Runs First and Can Be Re-Run

**Status:** Not started

**Story:** As the CRO developer, I want the resync to run before any Thought is read, and to be callable again before Epic 3 and 4, so those phases always start from current lists.

**Done when:** Feature 02's Pass 1 refuses to start if the `last_synced_at` values are
older than this run. The resync is one call that works at any time.
Acceptance test: the row counts in `brains` and `thebrain_types` equal
the counts in TheBrain's live lists when the resync runs.
