# User Story 04 — Insert and Vector Query Work

**Status:** Done

**Story:** As the CRO developer, I want each candidate to insert a row and run a similarity query, so I know it handles `vector(768)`.

**Done when:** Each candidate inserts a test row into `chunks` with a 768-dimension embedding and returns it from a similarity query. The test rows are deleted afterwards.

**Notes:** Feature 02 Story 05 already proved this directly in Postgres; this story proves it through the MCP.
2026-11-06, both candidates pass.
pgvector-cro: upsert_embedding inserted a row with a real
nomic-embed-text vector (768 numbers); similarity_search returned it
at distance 0. postgres-cro: pg_execute_code inserted a row with a
vector built in SQL (vector_dims 768); an ORDER BY embedding <=>
query returned it at distance 0. All test rows were deleted and
chunks is back to 0 rows.
Also passed 2026-11-06: pgvector-cro hybrid_search (score 0.55),
explain_similarity_query (plan returned; Seq Scan, as expected with
no vector index), create_vector_index (HNSW cosine; dropped after);
postgres-cro pg.vector.search, hybridSearch and validate.
Findings: pgvector-cro does not embed text; the vector must be passed
in as a literal list. A hand-typed list came out the wrong length
twice and the dimension check rejected it, so a real client should
pass the vector in code. pgvector-cro has no delete tool, so cleanup
went through postgres-cro. pg.vector.search defaults to L2 distance
and returns only distance unless select is set.
