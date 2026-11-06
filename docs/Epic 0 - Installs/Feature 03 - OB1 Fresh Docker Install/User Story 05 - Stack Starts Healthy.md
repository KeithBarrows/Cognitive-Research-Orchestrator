# User Story 05 — Stack Starts Healthy

**Status:** Done 2026-11-05

**Story:** As the CRO developer, I want every OB1 service to start
and stay healthy, so the brain is ready to use.

**Done when:** `docker compose ps` shows all services running, with
those that have health checks reporting healthy.

**Notes:** 12 services (Studio, Auth, Storage, the API gateway, the
pooler, Ollama and others). All healthy after a fresh start and after
a restart. Upstream asks for about 8 GB of RAM; Docker has about 16.5
GB. Upstream's README says Kong, but current Supabase uses Envoy as
the gateway. It routed `/functions/v1` correctly, so the Kong wording
did not matter.
