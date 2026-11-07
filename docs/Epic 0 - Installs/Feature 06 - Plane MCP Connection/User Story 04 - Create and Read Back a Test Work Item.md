# User Story 04 — Create and Read Back a Test Work Item

**Status:** Done

**Story:** As the CRO developer, I want to create and read back a test Work Item, so I know writes work through this connection.

**Done when:** A test Work Item is created in CRO, read back by id, and then deleted.

**Notes:** Delete it afterwards. The real 2-3 starter Work Items are Epic 2's job. In this Plane version the API path says `work-items`.

**Result:** 2026-11-06: created "plane-cro smoke test (delete me)" in
CRO (CRO-1), read it back by id with matching fields, then deleted it.
A work item list for CRO afterwards returned 0 items. `workitem count`
returned HTTP 404 on this Plane version; not investigated, not needed
for this story.
