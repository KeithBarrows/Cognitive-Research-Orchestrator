# User Story 09 — No Data Leaves

**Status:** Done 2026-11-06

**Story:** As the CRO developer, I want Plane to need no cloud service at run time, so my tasks stay local.

**Done when:** Plane works with no internet-only dependency after images are pulled; any telemetry or outbound setting is found and turned off if possible.

**Notes:** is_telemetry_enabled is false in the instances table, and the code (license/bgtasks/telemetry_metrics.py, line 80) returns before sending anything when it is false. posthog_api_key is null in /api/instances/. No external hosts appear in the api, worker, beat-worker, live, web or admin logs; the space log only prints a locize.com promo message. INSTANCE_CHANGELOG_URL is a link the browser shows, not a server call. Not packet-checked (same level as OB1 Story 09).
