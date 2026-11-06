# User Story 02 — Data Stored on D Drive

**Status:** Done 2026-11-06

**Story:** As the CRO developer, I want Plane's data on the D drive, so it survives container rebuilds.

**Done when:** Postgres, Redis, RabbitMQ, uploads and proxy files appear under D:\Data\CRO\plane\ and data survives a restart.

**Notes:** Postgres, Redis, RabbitMQ, uploads (MinIO) and proxy files are under `D:\Data\CRO\plane\`. Problem found: the first plane-db init was interrupted (a container was force-removed while initdb ran), leaving global/pg_filenode.map missing and Postgres stuck in recovery mode. The folder held no data, so only `D:\Data\CRO\plane\pgdata` was cleared and a clean start worked. Lesson: never remove a container during first start. Restart persistence is Story 08.
