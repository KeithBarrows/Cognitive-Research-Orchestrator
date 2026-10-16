# Phase 1 Plan — Draft

**Status:** Draft. All 5 items `CURRENT.md`'s "Next checkpoint" requires
for approval now have content. This document is the proposal; it becomes
Active only once the user formally approves it (see `CURRENT.md` and
`DECISIONS.md`).

## 1. First vertical slice

**TheBrain/OB1 retrieval** — not repo-grounded retrieval. Repo-grounded
context recall was the project's original stated mission and already has
mature groundwork (`docs/capability-matrix.md`'s repository adapter work),
but this session's work concentrated entirely on TheBrain/OB1, so that
becomes the second slice, built on top of this one.

Scope: given a question, search `cro_index` (vector + full-text) for
candidates drawn from both TheBrain and OB1, expand 1-2 hops via the
cached graph `edges` table when useful, then re-read the live canonical
source (TheBrain or OB1) before answering. Read-only. No capture, no
writes, no standing directives, no skill auto-pull, no dashboard, no
public ingest — all deferred (see Exclusions).

**Dependency, not part of this slice's feature scope but required before
it can be tested:** a one-time bootstrap data flow. TheBrain is read
once, raw, and feeds both `cro_index` and a new local OB1 instance — one
direction only, TheBrain is never written back to. Separately, the
existing cloud OB1's thoughts are read once and transferred into the new
local OB1 (OB1-to-OB1, no TheBrain involved). Acceptance test 0 below is
this bootstrap flow itself — nothing else can be validated until it
holds.

## 2. Implementation language and dependencies

**C# / .NET**, chosen over the earlier draft TypeScript recommendation —
the user is a C# developer and can actually review this code over the
years it will run. None of OB1's own source is reused directly (CRO only
talks to it as a REST client), so matching OB1's implementation language
was a convenience argument, not a real requirement.

- **Hosting:** Kestrel (ASP.NET Core's native host) — not OWIN, which is
  the older, largely superseded .NET hosting standard.
- **Endpoints:** minimal API handlers, no MVC controllers.
- **Organization:** vertical slice architecture — code grouped by
  feature (endpoint + request + handler + validation together), not by
  technical layer. Tight coupling inside a slice is expected; low
  coupling between slices. Shared cross-cutting concerns (logging, auth,
  validation) go into endpoint filters/middleware, not a shared service
  layer that re-couples everything.
- **CQRS/mediator band:** both **MediatR** and **Mediator** kept open as
  options, decided per-slice as the app is built — not locked in now.
  - `MediatR` went commercial at v13 (dual-licensed; free community tier
    for personal/small use under $5M revenue) — fine for this project's
    scale, but a known constraint, not a silent surprise.
  - `Mediator` is the MIT-licensed, source-generator-based, AOT-friendly
    alternative with a near-identical API — the safer default if
    licensing terms ever matter.
  - CQRS/Event Sourcing may be used where it genuinely fits (e.g., the
    `cro_index` rebuild-from-source flow has an event-sourced flavor
    already, per the "disposable index" rule) — not mandated project-wide.
- **Validation:** FluentValidation.
- **Logging/instrumentation:** Serilog, sinking to the **already-running
  local Seq container** (`weatherstation-seq`, `datalust/seq:latest`,
  ports 5341/8080) — either shared with the existing weather-station
  project's logs or a second dedicated Seq instance if the user prefers
  not to mix them.
- **Data access:** Npgsql for Postgres + pgvector.

## 3. Initial schema boundaries

The draft `cro_index` Supabase/pgvector schema already sketched this
session: `nodes`, `chunks`, `edges`, `sync_state` (see `CURRENT.md`'s
"Current state" and the session memory file
`project_cro_index_schema_draft.md`). Sized against a 645,000-item scale
target (Jerry's Brain), independently validated against two separate
working OB1 implementations found in the integration survey
(`docs/ob1-integration-survey.md`).

## 4. Acceptance tests

**0. The bootstrap data flow itself, proven first.** TheBrain feeds
`cro_index` and the new local OB1, one direction, TheBrain never written
to. Success: content that exists only in TheBrain is findable through
both OB1 search and `cro_index`, each result correctly linked back to
its real TheBrain Thought ID. Nothing else is validated until this holds.

1. A question returns results drawn from both TheBrain and OB1, not just
   one source.
2. A result whose content only lives inside a TheBrain Note body is
   still found — proves `cro_index` closes TheBrain's known
   Note-search gap.
3. Every returned result is re-read from the live TheBrain/OB1 source at
   answer time — never served from the cached index alone.
4. A narrow query can surface 1-2 broader related items via one hop up
   the TheBrain graph, capped at 2 (existing serendipity rule).
5. Anything tagged `sensitivity_tier = restricted` is never returned
   without explicit override — makes the Kittery-privacy mechanism a
   hard requirement of this slice, not a someday feature.
6. A query with nothing good to find returns "nothing found," never a
   fabricated or low-confidence guess.
7. `cro_index` can be deleted and rebuilt from TheBrain + OB1 with zero
   data loss — proves the "disposable index" rule actually holds.

## 5. Explicit exclusions for Phase 1

- Repo-grounded retrieval (now the second slice)
- Any capture/ingest flow — the "please remember [link]" command, email
  ingestion, the public ingest site (read-only only this phase)
- The holistic dashboard
- Standing resurfacing directives (mechanism is understood, storage/
  trigger design is not built)
- Proactive skill-pull (manual queries only this phase — skills aren't
  wired into CRO's context yet)
- Write support of any kind
- Home Assistant integration
- The public-ingest OIDC/account-allowlist auth layer
- OB1's cloud-to-internal migration as an ongoing capability (the
  one-time bootstrap read is in scope per item 1's dependency note; a
  repeatable sync/migration tool is not)
