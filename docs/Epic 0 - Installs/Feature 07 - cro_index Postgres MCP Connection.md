# Feature 07 — cro_index Postgres MCP Connection

*(Part of Epic 0 — Installs. See `../phase-0-plan.md` for the full
Epic.)*

## Install

Trial **both** real candidates, keep whichever works — decided
2026-11-04. The Supabase MCP tools already available in this session
won't talk to a plain Postgres+pgvector container (they're built
against Supabase's own API layer, confirmed not generic). Two real,
current options take a plain connection string instead:

1. `mcp-server-pgvector` — pgvector-specific: similarity search,
   hybrid vector+full-text search, upserts, index management.
2. `postgres-mcp` (writenotenow) — broader: schema introspection,
   migration tracking, pgvector among other extensions.

Since this is all disposable Docker, run **both** as separate
containers against the same `cro_index` database (Feature 02).

## Test

For each candidate: schema creation against `cro_index` (the 8
designed tables), a real insert, and a vector similarity query — all
working end to end. Keep whichever actually works; kill the other.
No need to commit to one on paper first.

## Not yet designed

Which one wins — genuinely unknown until both are actually tried.
