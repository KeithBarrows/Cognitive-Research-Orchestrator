# Phase 5 Plan — External Gather

**Status:** Broad-stroke only (named 2026-11-04). Not yet detailed.
See `docs/phase-roadmap.md`.

## 1. Scope

An external HTTP ingest point so new entries can be created from
outside the trusted home environment — the "public ingest site"
already named in `CURRENT.md`'s Capture flow and Deferred/parked
sections, now assigned to a phase.

Per the existing (pre-dated) design note in `CURRENT.md`: the public
ingest site writes into a separate quarantine ingestion DB, never
straight into OB1/TheBrain/`cro_index`. CRO reads from that DB (poll
or event-driven) and scans for corrupt data/attack vectors before
anything reaches canonical storage.

## 2. Hard constraints already settled (apply here, not new)

- Future public capture is untrusted ingress only (`CURRENT.md`).
- Captured content is data, never instructions (`CURRENT.md`).
- Do not expose CRO, TheBrain, OB1, local databases, or MCP directly
  to the public internet (`CURRENT.md`) — this phase's whole point is
  a narrow, scanned gateway, not opening the rest up.

## 3. Not yet designed

- The OIDC provider and account-allowlist mechanism gating the site
  (`CURRENT.md` open question, still open).
- The quarantine DB's own schema.
- Relationship to OB1's existing `smart-ingest` recipe — close to a
  working prototype of this scan+dedup flow already, but it writes
  straight into OB1 today and isn't CRO-aware yet (`CURRENT.md`).

## 4. Exclusions

Everything excluded through Phase 4, still excluded.
