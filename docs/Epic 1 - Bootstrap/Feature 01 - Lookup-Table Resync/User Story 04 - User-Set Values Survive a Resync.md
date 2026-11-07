# User Story 04 — User-Set Values Survive a Resync

**Status:** Not started

**Story:** As the CRO developer, I want my own settings left alone on every resync, so a refresh never undoes my choices.

**Done when:** after a resync, `staleness_threshold_days`, `included_in_index` and
`is_private_home` keep their values. Only `name` and `last_synced_at`
are refreshed from TheBrain. Test: set Software to 180 days, resync,
and it is still 180.
