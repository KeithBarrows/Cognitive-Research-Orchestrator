# User Story 05 — A Missing Brain or Type Is Flagged, Not Deleted

**Status:** Not started

**Story:** As the CRO developer, I want anything that vanished from TheBrain kept and flagged, so no row or its links are lost.

**Done when:** a brain or Type that is in `cro_index` but not in the live list keeps
its row, and its `last_synced_at` is not updated. Every node that
points at it (one row per node, never per chunk) gets a `node_flags` row
with `flag_type = 'deleted'`, and `detail` names what vanished and the
date. Nothing in `cro_index` or OB1 is removed. If it comes back later,
the flag rows are removed, whether or not they were reviewed.

**Notes:** Decided 2026-11-07 (Keith): keep and flag, never delete; `node_flags`
rather than `sensitivity_tiers` or `thebrain_types`. A vanished
Thought is a different case, detected when Thoughts are re-read
(Features 02 and 04), not here. Removing the flag on return is a
proposal from review on 2026-11-09, not yet confirmed by Keith.
