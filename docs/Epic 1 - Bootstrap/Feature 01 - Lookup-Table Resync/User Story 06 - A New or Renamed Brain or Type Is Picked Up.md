# User Story 06 — A New or Renamed Brain or Type Is Picked Up

**Status:** Not started

**Story:** As the CRO developer, I want new and renamed items picked up on the next run, so the lists don't go stale.

**Done when:** a new Type shows up as a new row. A renamed Type keeps its id and shows
the new name. A new brain starts with `included_in_index` set to a safe
default, and Keith decides on it later; its Types come in with it, and
its Thoughts are read only once `included_in_index` is true.
