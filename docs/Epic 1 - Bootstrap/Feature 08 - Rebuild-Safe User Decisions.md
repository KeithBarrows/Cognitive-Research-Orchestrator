# Feature 08 — Rebuild-Safe User Decisions

*(Part of Epic 1 — Bootstrap. See `../phase-1-plan.md` for the full
Epic; see `../phase-roadmap.md` for the Plane EPIC/FEATURE/USER STORY
tagging convention this file is meant to seed.)*

## Scope

New 2026-11-05. `cro_index` is disposable, but some of its values are
the user's own decisions and exist nowhere else, so a rebuild would
silently lose them. Before any delete or rebuild, CRO exports them to
a file; after the rebuild it re-applies them. This keeps `cro_index`
disposable without losing the user's work. The set:

- `brains.is_private_home` and `brains.included_in_index`
- `thebrain_types.staleness_threshold_days`
- `node_links.confirmed_by_user`, and every `node_links` row the user
  created (`detection_method = 'user_manual'`, `link_type =
  'confirmed_same_entity'`), since CRO cannot recompute those
- `node_flags.reviewed_by_user`

Re-apply matches rows by natural keys (brain id, Type id, and the
source ids of both sides of a link or flag), never by CRO's own uuids.
A decision whose target no longer exists after the rebuild is not
dropped silently: it is listed in the run report. The export file
lives inside the trusted environment like every other store, outside
`cro_index` itself.

## Schema touched

`brains`, `thebrain_types`, `node_links`, `node_flags` (read for
export, written on re-apply). No new columns.

## Dependency

Needs Features 01–07 to have produced the rows being exported.

## Acceptance test

`../phase-1-plan.md` test 1 (Rebuild safety): delete `cro_index` and
rebuild it from TheBrain and OB1. Every derived row comes back
equivalent, compared by source ids, and every user-set value is
re-applied and matches what was exported before the delete.

## Not yet designed

Where the export file lives (path and format) — to be settled in
Epic 0 or Epic 1.
