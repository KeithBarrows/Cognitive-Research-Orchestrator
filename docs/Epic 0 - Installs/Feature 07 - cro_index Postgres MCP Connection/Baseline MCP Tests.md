# Baseline MCP Tests — cro_index

Recorded 2026-11-06 (Feature 07, Stories 01-04). These are the first
tests of how Claude Code reaches `cro_index` through two MCP servers.
They are the starting point for the CRO test suite. All 10 passed.

## Setup

- Servers: `pgvector-cro` (mcp-server-pgvector 0.1.0, run with
  `mcp<2`) and `postgres-cro` (writenotenow/postgres-mcp v3.1.0,
  `--tool-filter codemode`). Launchers are in `src\Infra`.
- Database: `cro_index`, Postgres 17.11, `127.0.0.1:5433`.
- Test table: `chunks`. It must start with 0 rows and only the two
  indexes `chunks_pkey` and
  `chunks_node_type_node_id_chunk_index_key`.
- Test rows use `node_type = 'cro-smoke-test'` so they are easy to
  find and delete.
- Test vector: a real 768-number embedding from the local Ollama
  container (`nomic-embed-text`, `127.0.0.1:11434`). Text:
  "Feature 07 Story 04 smoke test row. Delete me."
- pgvector-cro does not embed text. The vector must be passed in as a
  literal list of numbers. A hand-typed list came out the wrong
  length twice, so generate the vector in code.

## Tests

| # | Server | Tool | Input | Expected result | Result |
| --- | --- | --- | --- | --- | --- |
| 1 | postgres-cro | pg_execute_code | List tables in `public` | 12 tables: the 11 from V002 plus `flyway_schema_history` | Pass |
| 2 | pgvector-cro | list_vector_tables | none | One column: `chunks.embedding`, 768 dimensions | Pass |
| 3 | pgvector-cro | describe_vector_table | `chunks` | 7 columns, 2 btree indexes | Pass |
| 4 | pgvector-cro | upsert_embedding | `chunks`, test vector, test metadata | Row id returned | Pass |
| 5 | pgvector-cro | similarity_search | Same vector, k=3 | The test row, distance 0 | Pass |
| 6 | postgres-cro | pg_execute_code | Insert a row with a SQL-built vector, query with `<=>`, delete | `vector_dims` 768; row returned at distance 0; 1 row deleted | Pass |
| 7 | pgvector-cro | hybrid_search | Same vector, text "pgvector similarity" | The test row, score about 0.55 | Pass |
| 8 | pgvector-cro | explain_similarity_query | Same vector, k=3 | A plan is returned (Seq Scan with no vector index) | Pass |
| 9 | pgvector-cro | create_vector_index | `chunks.embedding`, HNSW, cosine | Index `chunks_embedding_hnsw_cosine_idx` created | Pass |
| 10 | postgres-cro | pg.vector.search, hybridSearch, validate | Stored vector | search: distance 0; hybridSearch: combined score about 0.55; validate: valid, 768 | Pass |

Negative test (also passed): pgvector-cro rejected a vector of the
wrong length with "expected 768 dimensions" and wrote nothing.

## Cleanup (run after every test)

1. Drop any test index (test 9): `DROP INDEX IF EXISTS
   public.chunks_embedding_hnsw_cosine_idx`.
2. Delete test rows: `DELETE FROM chunks WHERE node_type =
   'cro-smoke-test'`. pgvector-cro has no delete tool, so use
   postgres-cro.
3. Confirm `chunks` has 0 rows and only the 2 original indexes.

## Known limits

- Test 8 cannot show the vector index being used. On a 1-row table
  the planner always picks a Seq Scan. Re-test with real data in
  Epic 1.
- `pg.vector.search` defaults to L2 distance and returns only the
  distance unless `select` is set.
- Tests 4 and 9 change the database. Test 9 changes the schema
  outside Flyway, so it must always be dropped afterwards.
- Not tested: `postgres-cro` write tools other than raw SQL,
  `pg.vector.createIndex`, and any role with fewer rights
  (Story 06).
