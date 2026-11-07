# Feature 07 — Note-Embedded Cross-Brain Link Detection

*(Part of Epic 1 — Bootstrap. See `../../phase-1-plan.md` for the full
Epic; see `../../phase-roadmap.md` for the Plane EPIC/FEATURE/USER STORY
tagging convention this file is meant to seed.)*

## Scope

New 2026-11-05. `node_links`' `link_type = 'native'` was defined
2026-11-04 as "a real TheBrain cross-brain link, if one is ever found
in active use" — now confirmed found: "Health Records" (Growth)'s
Note body contains a `brain://api.thebrain.com/{brainId}/{thoughtId}/
{slug}` URI resolving (decoded live, base64url → GUID) to "Health
History" in Filing Cabinet.

**This link does not appear in the `/graph` response at all** — that
same Thought's `jumps` array was confirmed live to be empty — so it
cannot be found by the `edges` walk Feature 02 already does. It needs
its own pass: scan every Note body (via `GET /api/notes/{brainId}/
{thoughtId}`) for `brain://` URIs, decode each one's base64url-encoded
brain/Thought GUIDs, and record a `node_links` row (`link_type =
'native'`, `detection_method = 'note_brain_link'`) pointing at the
resolved Thought.

## Schema touched

`node_links` (`native` rows, `detection_method = 'note_brain_link'`).

## Dependency

Runs during/after Feature 02's raw read, since it needs every brain's
Note bodies already fetched and every `thebrain_nodes` row already
populated (both sides of the link need to resolve to a real row).

## Acceptance test

Note-embedded cross-brain links. Independently scan every Note body
for `brain://` URIs and decode their GUID pairs. The set of
`node_links` rows with `link_type = 'native'` and `detection_method =
'note_brain_link'` must equal that set, each pointing at the correct
target Thought. ("Health Records" to "Health History" is one
instance, not the test.)

## Not yet designed

Whether `brain://` URIs can appear anywhere other than a Note body
(e.g. inside another attachment type) is unconfirmed — only the Note
case has been observed live so far. Treat other locations as
out-of-scope until one is actually found.
