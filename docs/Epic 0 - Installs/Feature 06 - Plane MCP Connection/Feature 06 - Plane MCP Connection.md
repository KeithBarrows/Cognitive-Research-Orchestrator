# Feature 06 — Plane MCP Connection

*(Part of Epic 0 — Installs. See `../../phase-0-plan.md` for the full
Epic.)*

## Install

A new Plane MCP server connection, **served from the laptop only**
(same non-negotiable as everything else — never the desktop), pointed
at the new local Plane instance (Feature 04). Confirmed live during
Epic 1 planning: the Plane MCP tool already available in this session
points at the *wrong* target entirely — the existing writing/
CreativeOS workspace, not a CRO project. It does not follow this
Epic's new install automatically; a new connection has to be
configured by hand.

## Test

- The new connection lists the "CRO" project (Feature 04) and no
  other project — confirming it's pointed at the new instance, not
  the old writing/CreativeOS workspace.
- A test Work Item can be created and read back through this
  connection.

## Not yet designed

Nothing specific — this is mechanical once Feature 04 exists.
