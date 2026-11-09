# User Story 07 — Resync Runs First and Can Be Re-Run

**Status:** Not started

**Story:** As the CRO developer, I want the resync to run before any Thought is read, and to be callable again before Epic 3 and 4, so those phases always start from current lists.

**Done when:** Feature 02's Pass 1 refuses to start unless every brain and Type
that is live in TheBrain has a `last_synced_at` from this run. Rows
flagged `deleted` (Story 05) are not checked, so a vanished brain does
not block Pass 1. The resync is one call that works at any time.
Acceptance test: every brain and Type in TheBrain's live lists has a row
in `brains` or `thebrain_types`, and any extra rows are flagged
`deleted`.
