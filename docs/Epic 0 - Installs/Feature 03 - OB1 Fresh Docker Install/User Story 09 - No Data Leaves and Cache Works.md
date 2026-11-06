# User Story 09 — No Data Leaves, Cache Works

**Status:** Done 2026-11-05 (cache verified; outbound traffic not
packet-checked)

**Story:** As the CRO developer, I want no thought data or embedding
request to leave the laptop, so OB1 stays inside the trusted boundary.

**Done when:** A capture and a search work with no embedding or data
call to any outside service, and the Deno cache holds the package.

**Notes:** Ruling 2026-11-05: package and image downloads are allowed;
they send no data of ours. The Edge Functions import
`jsr:@supabase/supabase-js@2`, which Deno fetches from the JSR
registry on first use and keeps in the named volume `deno-cache`
(`/root/.cache/deno`). The cache holds `remote/https/jsr.io` and
stayed at 13 MB across `down` and `up`. Network traffic was not
watched, so "no refetch" is inferred, not observed. Lost only by
`down -v`, `docker volume rm` or prune, or a Docker Desktop reset.
Embeddings come from the local Ollama container only. The gateway,
pooler and Ollama are bound to `127.0.0.1` only (decided
2026-11-05; upstream binds them on every interface).
