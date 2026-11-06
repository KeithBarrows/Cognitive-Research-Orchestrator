# User Story 11 — Update and Delete Trial

**Status:** Done 2026-11-05

**Story:** As the CRO developer, I want to update and delete a
thought through OB1's API, so CRO can keep OB1 current.

**Done when:** `integrations/rest-api` is tried on this stack with
Ollama in place of a cloud key. Update and delete are confirmed or
ruled out, and whether delete is hard or soft is recorded.

**Notes:** Upstream `integrations/rest-api` was ruled out by reading
its source (it was not run, because running it would break the
no-cloud rule). It hardcodes `https://openrouter.ai/api/v1/embeddings`
and `https://api.openai.com/v1/embeddings` with no local base-URL
setting, hardcodes `EMBEDDING_DIMENSION = 1536` (ours is 768), and
needs the `enhanced-thoughts` schema plus cloud classifier calls.
Built a thin REST layer instead, in `03a`: `functions/update` (PUT,
body `{id, content?, metadata?}`; re-embeds through Ollama,
recomputes the fingerprint, merges metadata) and `functions/delete`
(DELETE `?id=<uuid>`, a hard delete). Mounted into the `functions`
service by our `docker-compose.yml`; no `03b` folder needed. Tested:
update, metadata-only update, delete, delete-again 404, bad id 400,
unknown id 404, wrong method 405. Delete is hard; the OB1
maintainer prefers deprecation, so revisit a soft delete
(`deleted_at`) only if CRO needs undelete.
