# User Story 04 — Vector Extension Enabled

**Status:** Done 2026-11-05

**Story:** As the CRO developer, I want pgvector enabled
automatically, so a fresh start is ready with no manual step.

**Done when:** A fresh database lists `vector` in `\dx`.

**Notes:** The extension is now created by
`migrations\V001__enable_pgvector.sql` (the old `init\` folder was
removed). `vector` 0.8.7 confirmed.
