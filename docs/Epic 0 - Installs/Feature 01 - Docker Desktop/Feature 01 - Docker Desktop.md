# Feature 01 — Docker Desktop

*(Part of Epic 0 — Installs. See `../../phase-0-plan.md` for the full
Epic; see `../../phase-roadmap.md` for the Plane EPIC/FEATURE/USER STORY
tagging convention this file is meant to seed.)*

## Install

Confirm Docker Desktop is already installed and running on the
laptop; install it if not. Every other Feature in this Epic runs
inside it.

## Test

Docker Desktop reports running and healthy (`docker info` succeeds,
or the Docker Desktop UI shows it running). No container-level test
yet — this Feature is the prerequisite for every other one.

## Result

**Done 2026-11-05.** Verified on the laptop. `docker --version`
reports 29.9.2 and `docker compose version` reports v5.6.1.
`docker info` succeeded once Docker Desktop was started: server
29.9.2, Docker Desktop, 8 CPUs, about 16.5 GB memory. No containers
existed at the start. Docker Desktop was installed but not running
when first checked; it had to be launched by hand.

## Not yet designed

Nothing — this is the simplest Feature in the Epic.
