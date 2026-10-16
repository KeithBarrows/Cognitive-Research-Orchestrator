# OB1 Integration Survey

**Status:** Research notes from a 2026-10-16 review of `D:\Repos\KeithBarrows\OB1`
(a fork of `https://github.com/NateBJones-Projects/OB1`), synced to upstream
`main` the same day. This is a survey of what exists, not a design document —
nothing here is approved for CRO implementation.

**Scope:** OB1 ships far more than the 4-6 MCP tools `docs/capability-matrix.md`
tested directly. This document catalogs the extensions, primitives, schemas,
integrations, recipes, and skills reviewed, so that catalog isn't lost. See
`CURRENT.md` for the handful of findings significant enough to also live there.

## High-impact findings

These directly validate or fill a gap in CRO's own design work.

### A complete self-hosted reference build already exists

`zebras/open-brain-self-hosted-guide.md` (local file, gitignored, not in the
public repo) documents a working self-hosted OB1: PostgreSQL 16 + pgvector in
Docker replacing Supabase Postgres, a plain Node.js/Express MCP server
(`@modelcontextprotocol/sdk` + `pg` + raw SQL) replacing the Supabase Edge
Function, OpenRouter kept external for embeddings/metadata.

Its schema is close to identical to CRO's own draft `cro_index` schema: a
`thoughts` table with an HNSW index on `embedding vector(1536)`, a GIN index
on a `metadata` JSONB column, a B-tree on `created_at DESC`, and a
`match_thoughts()` SQL function. Independent confirmation the draft shape is
right. Includes full, readable TypeScript source for the 4 MCP tools
(`search_thoughts`, `list_thoughts`, `thought_stats`, `capture_thought`).

**Caveat:** written for a specific multi-host lab setup (macvlan networking
across several Docker hosts, static routes) — strip that out for a
single-machine deployment; only the Postgres+pgvector+Node/Express pattern
and the schema/tool code are transferable. Its own appendix flags its auth as
weak for production (single shared key via query string) — the newer
`enhanced-mcp`/`rest-api` integrations already fixed this by forbidding
query-string keys; don't copy the older pattern.

### `recipes/local-brain-no-mcp` — closest match to the decided architecture

A documented "deliberate exception to canonical OB1" for local/offline use:
full Supabase stack self-hosted on one LAN host, an Ollama sidecar for local
embeddings, exposed as plain HTTPS endpoints (`/capture`, `/search`,
`/list`) instead of MCP, called via `curl` from a companion skill
(`skills/ob1-local-http`). ~8GB RAM, ~5GB disk, one-time setup script.
Directly validates two things already decided for CRO: OB1 reached over
REST (not a second MCP hop), and the full stack running on one machine.

### `recipes/local-ollama-embeddings`

Replaces cloud embedding calls with local Ollama — zero API cost, works
offline. Three tested models; `gte-qwen2-1.5b-instruct-embed-f16` (1536 dim)
is flagged "drop-in compatible with default Open Brain schema (no ALTER
needed)" — relevant if `cro_index`'s embedding dimension needs to match.

### `schemas/agent-memory` + `integrations/agent-memory-api` — the biggest find

A governed memory model built for exactly the question "can an AI write
something back that later gets treated as a fact or an instruction":
`can_use_as_instruction` defaults `false`, `can_use_as_evidence` defaults
`true`, `requires_user_confirmation` defaults `true`, `review_status`
defaults `pending`. The API has `/recall` (pull scoped context before an
agent starts work) and `/writeback` (save compact memory after, with
built-in blocking of raw transcripts/secrets/reasoning dumps before
storage), plus a review lifecycle (`confirm/edit/reject/restrict/stale/
dispute/supersede`).

This is a near-complete working model for CRO's two still-undesigned
concepts: the "proactive skill-pull" flow (recall-before-work) and
"standing resurfacing directives" (writeback-after-work, with a
confirmation step before anything becomes an instruction CRO acts on
unprompted).

### `schemas/provenance-chains` — extends the sensitivity-tier finding

Adds `derived_from`, `derivation_method`, `derivation_layer`, `supersedes`
columns plus a `trace_provenance()` function with cycle detection. Notable:
it **automatically redacts restricted-tier content when something else's
ancestry is traced back through it** — not just blocked at write time (as
`enhanced-mcp`'s sensitivity tier does), but also blocked on read, later,
indirectly.

### Household data: attribution, not access separation

**Correction from the user (2026-10-16):** the household/CRM extensions and
`primitives/shared-mcp`/`rls` describe a scoped-access pattern (a separate
server, limited table access) for giving a spouse access to *only their own*
data. That is the wrong shape here — Keith and Kittery have been married
almost 36 years and share everything; there is no need to wall off her data
from his. **The actual need is simpler: tag which facts are specifically
hers** (e.g., her EDS diagnosis) so the two people's medical histories don't
get merged or confused with each other in a shared space — an attribution
field, not an access-control boundary.

### `recipes/gmail-smart-pull` — real email-ingestion pattern

Engagement filter (only threads replied to, unless starred/important),
per-message sensitivity tiering *before* anything leaves the machine,
relationship-tier classification via a contacts cache, LLM atomization of
long messages, RFC 2822 threading headers for later reply-graph building.
Outputs a portable JSON "pack" file rather than writing to Supabase
directly — separates the pull step from the ingest step. Directly informs
CRO's deferred "email ingestion source" item.

### `recipes/brain-backup`

Exports every Supabase table to dated JSON files via paginated PostgREST
calls. One plausible piece of the "laptop sync" requirement — not a full
sync solution, just an export/import transport.

### `integrations/kubernetes-deployment` — a Supabase-free fallback

Raw PostgreSQL+pgvector in one pod, MCP server as a sidecar, supports a
local LLM (Ollama/llama.cpp) for both embeddings and chat. Only exposes the
stock 4-tool MCP, not `enhanced-mcp`. Proves a Supabase-free local
deployment is a real, working option if Supabase ever becomes the blocker.

## Secondary patterns (real, lower priority)

- `schemas/crm-person-tiers` — 4-tier relationship taxonomy
  (`connected`/`contact`/`known`/`unknown`) with activity-based
  auto-promotion. Relevant if CRO ever needs to classify "who is this
  person" for routing, separate from the attribution-tagging need above.
- `recipes/typed-edge-classifier` — refuses to run on unpriced LLM models
  unless explicitly overridden. Good safety pattern for any CRO job that
  spends money per call.
- `recipes/editorial-policy` — a 40-rule "constitution" enforced by a
  weekly auditor against synthesis drift. Relevant if CRO ever
  auto-generates summaries (see the `entity-wiki` search-pollution finding
  already in `CURRENT.md`).
- `recipes/life-engine` — "one loop, one skill" proactive briefing via
  Telegram/Discord. Conceptually close to the standing-directive idea, but
  built as one generic loop rather than per-rule directives — a useful
  contrast case.
- `recipes/edge-function-cost-optimization` — ~73% invocation reduction via
  server consolidation/session reuse/caching. Relevant once CRO runs its
  own backend functions.
- `recipes/authorship-edges` — classifies every thought `self`/`other`/
  `mixed`/`machine`/`unknown`. Relevant for distinguishing the user's own
  words from AI-generated summaries during retrieval.
- `recipes/brain-health-monitoring` + `recipes/brain-smoke-test` — SQL
  health views plus a one-shot install-verification harness. Useful
  pattern for CRO's own health-check surface once self-hosted.
- `recipes/google-activity-import` — imports Search/Gmail/Maps/YouTube/
  Chrome history from Google Takeout, including Gemini prompt+answer pairs.
  A second-tier ingestion source if ever wanted.
- `dashboards/open-brain-dashboard-next` — 9-page reference UI (Browse,
  Search, Add-to-Brain with dry-run, Audit, Duplicates resolution, Agent
  Memory review queue). Not the dashboard being migrated (that's a
  separate Lovable-built `qfcg-planning` project), but worth a glance as UI
  prior art.
- `skills/heavy-file-ingestion` — converts heavy files to agent-friendly
  markdown/CSV. Note: a skill of this same name already exists in this
  Claude Code environment's own skill list — possible existing dependency,
  not something to rebuild.
- `skills/auto-capture` — a session-end capture protocol (the AI client
  follows a save-what-mattered routine at session close, not a daemon).
  Relevant precedent for a CRO "capture what mattered this session"
  behavior.
- `recipes/atomizer`, `recipes/content-fingerprint-dedup` +
  `fingerprint-dedup-backfill` — splitting and dedup helpers that
  complement `gmail-smart-pull` and the fingerprint-dedup pattern already
  logged from `smart-ingest`.

## Not individually verified

Title/README skim only, or not reached — flagged for a future pass if ever
needed: `integrations/discord-capture`, `telegram-capture`,
`readwise-capture`, `hermes-agent-memory`, `openclaw-agent-memory`,
`consolidation-workers`, `entity-extraction-worker`; schemas
`brain-stats-daily`, `per-agent-identity`, `readwise-books`,
`recency-boosted-match-thoughts`, `text-search-trgm`, `thought-audit`,
`thought-work-claims`, `wiki-pages`, `workflow-status`; dashboards
`open-brain-dashboard`, `open-brain-dashboard-pro`, `ob1-canonical-landing`;
recipes `claudeception`, `panning-for-gold`, `thought-enrichment`,
`schema-aware-routing`, `bring-your-own-context`,
`adaptive-capture-classification`, `research-to-decision-workflow`,
`wiki-compiler`, `wiki-synthesis`, `daily-digest`, `weekly-digest`; skills
`competitive-analysis`, `deal-memo-drafting`, `financial-model-review`,
`meeting-synthesis`, `research-synthesis`, `work-operating-model`,
`world-model-diagnostic`, `openclaw-agent-memory` (these last 7 are generic
business-analyst skill packs — confirmed breadth, nothing architecturally
new for CRO).

## Already reviewed individually, logged in `CURRENT.md`

Not repeated here in full — see `CURRENT.md`'s "Current state" section:
`enhanced-mcp`, `rest-api`, `smart-ingest`, `schemas/entity-extraction`,
`schemas/typed-reasoning-edges`, `recipes/ob-graph`, `recipes/entity-wiki`.
