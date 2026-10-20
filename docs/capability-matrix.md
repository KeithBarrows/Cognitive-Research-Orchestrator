# CRO Integration Capability Matrix

**Status:** TheBrain, OB1, and repository adapter verified; Phase 0 capability discovery complete

**Last updated:** 2026-10-20 (OB1 section: added 2026-10-15 live re-investigation findings against real user data, 91 thoughts)

This matrix records verified integration behavior. A question mark means the capability has not yet been tested against the installed system. Desktop UI support does not imply API support.

## TheBrain Local API

**Discovery status:** Exercised against Local API `1.0` on 2026-10-11.

**Base URL:** `http://localhost:11522/api/`

**Authentication:** `Authorization: Bearer {apiKey}`

**Test isolation:** Write tests used a temporary Brain named `CRO API Discovery 2026-10-11`. No existing Brain was modified, and no API key is stored in this repository. All created Thoughts, links, Notes, and attachments were deleted. Cleanup through `DELETE /api/brains/{id}` returned HTTP 200 with `{}` twice, but the empty Brain shell remained listed and directly readable. Manual deletion of that Brain is required.

### Summary

| Capability | Status | Read | Write | CRO consequence |
|---|---|---:|---:|---|
| Thoughts | Supported | Yes | Yes | Safe basis for source capture with adapter validation |
| Thought Types | Supported with limitations | Yes | Yes | Types are Thoughts with undocumented `kind=2`; no dedicated create endpoint |
| Tags | Supported with limitations | Yes | Yes | Tags are Thoughts with undocumented `kind=4`; assignment is a graph link |
| Notes | Supported | Yes | Yes | Read explicitly; do not assume Note bodies are searchable |
| Attachments | Supported with limitations | Yes | Yes | Use Thought graph for a complete attachment view |
| Parents / Children / Jumps | Supported with limitations | Yes | Yes | Relation integers are undocumented and must be isolated in the adapter |
| Link Types | Unclear / partial | Partial | Partial | Do not make typed links an MVP dependency |
| Link direction/properties | Supported with limitations | Yes | Yes | Several fields are writable, but units and derived fields are undocumented |
| Native timestamps/history | Supported with limitations | Yes | No direct timestamp write | Normalize inconsistent timestamp representations |
| Calendar Events | Unsupported | No | No | Calendar integration must be deferred or use another supported interface |
| BrainBox | Unsupported | No | No | CRO cannot automate BrainBox through Local API `1.0` |
| Search | Supported with limitations | Yes | N/A | Combine API search with explicit Note reads and graph traversal |
| Bulk operations | Unsupported | No | No | All writes must be individually idempotent; no API transaction boundary |

### Thoughts

- **Status:** Supported.
- **Read endpoints:**
  - `GET /api/thoughts/{brainId}/{thoughtId}`
  - `GET /api/thoughts/{brainId}?nameExact={name}`
  - `GET /api/thoughts/{brainId}/{thoughtId}/graph?includeSiblings={bool}`
  - `GET /api/thoughts/{brainId}/pins`
- **Write endpoints:**
  - `POST /api/thoughts/{brainId}`
  - `PATCH /api/thoughts/{brainId}/{thoughtId}` using a JSON Patch array
  - `DELETE /api/thoughts/{brainId}/{thoughtId}`
  - `POST|DELETE /api/thoughts/{brainId}/{thoughtId}/pin`
- **Required identifiers/parameters:** `brainId`; `thoughtId` for ID access; `nameExact` for exact-name lookup. Creation accepts `name`, `kind`, `label`, `aliases`, `typeId`, `sourceThoughtId`, `relation`, and `acType`.
- **Verified writes:** create, update `typeId`, `label`, and `aliases`, and delete.
- **Limitations:** exact-name lookup returns the first match; `kind`, `relation`, and `acType` are integer fields without documented enum names; JSON Patch paths and allowed fields are not enumerated by the API documentation.
- **Design impact:** CRO must prefer IDs after resolution, check near-duplicates before creation, and keep undocumented integer mappings inside the TheBrain adapter rather than domain models.

### Thought Types

- **Status:** Supported with limitations.
- **Read endpoint:** `GET /api/thoughts/{brainId}/types`.
- **Write mechanism:** create through `POST /api/thoughts/{brainId}` with `kind=2`; assign to a Thought by patching `/typeId`.
- **Required identifiers/parameters:** `brainId`; Type Thought ID when assigning.
- **Verified behavior:** a created Type appeared in the types list and in `ThoughtGraphDto.type`; assigning it also created the graph relationship expected by TheBrain.
- **Limitations:** there is no dedicated Type create/update endpoint; `kind=2` is observed rather than documented. Some existing Brains with no Types returned HTTP 400 instead of an empty array.
- **Design impact:** the adapter must validate returned data and handle an empty-Type failure separately from authentication or server failures. Type creation should remain conservative to avoid vocabulary proliferation.

### Tags

- **Status:** Supported with limitations.
- **Read endpoints:**
  - `GET /api/thoughts/{brainId}/tags`
  - `GET /api/thoughts/{brainId}/{thoughtId}/graph` (`tags` collection)
- **Write mechanism:** create through `POST /api/thoughts/{brainId}` with `kind=4`; assign by creating a hierarchy link with the Tag as `thoughtIdA`, the tagged Thought as `thoughtIdB`, and `relation=1`; remove by deleting that link.
- **Required identifiers/parameters:** `brainId`, Tag Thought ID, target Thought ID, and link ID for removal.
- **Verified behavior:** Tag creation, assignment, graph readback, link deletion, and graph removal.
- **Limitations:** no dedicated assign/remove Tag endpoint; `kind=4` and the link convention are undocumented. Some Brains with no Tags returned HTTP 400 rather than an empty array.
- **Design impact:** CRO can implement `Incomplete`, `Needs Review`, `Stale`, and similar tags, but Tag operations must be encapsulated and verified after writes.

### Notes

- **Status:** Supported.
- **Read endpoints:**
  - `GET /api/notes/{brainId}/{thoughtId}` for Markdown
  - `GET /api/notes/{brainId}/{thoughtId}/text`
  - `GET /api/notes/{brainId}/{thoughtId}/html`
- **Write endpoints:**
  - `POST /api/notes/{brainId}/{thoughtId}/update`
  - `POST /api/notes/{brainId}/{thoughtId}/append`
- **Required identifiers/parameters:** `brainId`, `thoughtId`, and body `{ "markdown": "..." }`.
- **Verified behavior:** create/update, append, and readback in all three representations. Note metadata includes `modificationDateTime`.
- **Limitations:** no explicit Note delete endpoint; Notes also appear as an attachment with `type=1` and `isNotes=true`. A unique string in a newly written Note was not returned by full search, so Note-content indexing is unsupported or not reliably immediate.
- **Design impact:** CRO must fetch Notes explicitly for authoritative context and must not rely on `/api/search` to discover Note contents.

### Attachments

- **Status:** Supported with limitations.
- **Read endpoints:**
  - `GET /api/attachments/{brainId}/{attachmentId}/metadata`
  - `GET /api/attachments/{brainId}/{attachmentId}/file-content`
  - `GET /api/attachments/{brainId}/by-location?location={value}&type={type}`
  - `GET /api/thoughts/{brainId}/{thoughtId}/attachments`
  - `GET /api/thoughts/{brainId}/{thoughtId}/graph`
- **Write endpoints:**
  - `POST /api/attachments/{brainId}/{thoughtId}/file` with multipart field `file`
  - `POST /api/attachments/{brainId}/{thoughtId}/url?url={url}&name={name}`
  - `DELETE /api/attachments/{brainId}/{attachmentId}`
- **Required identifiers/parameters:** `brainId`, `thoughtId`, and then `attachmentId`; URL lookup optionally takes attachment `type` (`3` for external URL).
- **Verified behavior:** URL creation and exact-location lookup; file upload; metadata; graph listing; binary download with content type and length; search by attachment filename; deletion.
- **Limitations:** upload responses did not return the created attachment ID. The dedicated Thought-attachments endpoint omitted the tested URL attachment while the Thought graph returned Notes, URL, and file attachments. The OpenAPI multipart schema describes an `IFormFile` shape but does not clearly name the `file` field. File-size limits are not documented.
- **Design impact:** use `by-location` for URL deduplication and `ThoughtGraphDto.attachments` for a complete inventory. After file upload, re-read the graph or modification log to resolve the new attachment ID.

### Parents, Children, and Jumps

- **Status:** Supported with limitations.
- **Read endpoint:** `GET /api/thoughts/{brainId}/{thoughtId}/graph?includeSiblings={bool}` returns `parents`, `children`, `jumps`, `siblings`, `tags`, `type`, `links`, and `attachments`.
- **Write endpoints:**
  - `POST /api/thoughts/{brainId}` with `sourceThoughtId` and `relation`
  - `POST /api/links/{brainId}` with `thoughtIdA`, `thoughtIdB`, `relation`, and optional `name`
  - `DELETE /api/links/{brainId}/{linkId}`
- **Required identifiers/parameters:** `brainId`, endpoint Thought IDs, and relation integer.
- **Verified mappings:** `relation=1` produced a hierarchy relationship; `relation=3` produced a jump. For hierarchy/tag links, `thoughtIdA` is the parent or Tag and `thoughtIdB` is the child or tagged Thought.
- **Limitations:** relation enum names, duplicate-link behavior, ordering, and cycle handling are not documented.
- **Design impact:** explicit repository relationships can be represented, but CRO must use named adapter constants, read back every graph write, and avoid speculative high-volume linking.

### Link Types

- **Status:** Unclear / partial.
- **Read support:** `LinkDto.typeId` is returned by link and graph endpoints.
- **Write support:** patching `/typeId` on a link succeeded when given an existing `kind=2` Type Thought ID.
- **Endpoints:**
  - `GET /api/links/{brainId}/{linkId}`
  - `GET /api/links/{brainId}/{thoughtIdA}/{thoughtIdB}`
  - `PATCH /api/links/{brainId}/{linkId}`
- **Required identifiers/parameters:** `brainId`, `linkId`, and a Type UUID.
- **Limitations:** there is no endpoint to list or create Link Types as a distinct entity. Creating a Thought with `kind=3` was rejected. The API accepted a normal `kind=2` Type as a link `typeId`, but the relationship between desktop Link Types and these Type Thoughts is undocumented.
- **Design impact:** typed links must not be an MVP dependency. CRO may preserve and read `typeId`, but automation should use untyped links or reviewed link names until the desktop semantics are confirmed.

### Link Direction and Properties

- **Status:** Supported with limitations.
- **Read endpoints:**
  - `GET /api/links/{brainId}/{linkId}`
  - `GET /api/links/{brainId}/{thoughtIdA}/{thoughtIdB}`
  - Thought graph endpoints
- **Write endpoints:**
  - `POST /api/links/{brainId}`
  - `PATCH /api/links/{brainId}/{linkId}` using JSON Patch
  - `DELETE /api/links/{brainId}/{linkId}`
- **Verified writable properties:** `name`, `direction`, `color`, `thickness`, and `typeId`. Link creation sets endpoints and `relation`.
- **Verified read properties:** `thoughtIdA`, `thoughtIdB`, `relation`, `direction`, `meaning`, `typeId`, `name`, `color`, `thickness`, and timestamps.
- **Limitations:** writes were eventually visible rather than safe to assume immediately. Setting thickness to `3` read back as `300`, indicating an undocumented unit conversion. Attempting to change `meaning` did not persist, suggesting it is derived or read-only. Valid direction, meaning, relation, color, and thickness ranges are undocumented.
- **Design impact:** re-read after mutation, treat `meaning` as derived, and avoid styling writes in the MVP. Direction and relation require adapter-level enum mappings and tests.

### Native Timestamps and Modification History

- **Status:** Supported with limitations.
- **Read fields:**
  - Thoughts and links: `creationDateTime`, `modificationDateTime`
  - Attachments: creation, modification, and optional file-modification timestamps
  - Notes: `modificationDateTime`
- **History endpoints:**
  - `GET /api/thoughts/{brainId}/{thoughtId}/modifications?maxLogs={n}&includeRelatedLogs={bool}`
  - `GET /api/brains/{brainId}/modifications?maxLogs={n}&startTime={dateTime}&endTime={dateTime}`
- **Required identifiers/parameters:** `brainId`; optionally `thoughtId`; `maxLogs` is required. Thought history also requires `includeRelatedLogs`.
- **Verified behavior:** logs covered Thought creation and field changes, Type assignment, link creation/property changes, Note changes, attachment creation/deletion, and related entities.
- **Limitations:** enum names for `sourceType` and `modType` are not documented; timestamp formatting was inconsistent between direct endpoints and search results, including values with and without a `Z` suffix. No direct timestamp-write operation exists.
- **Design impact:** normalize timestamps to a defined internal instant only when an offset is present; otherwise retain the raw value and local-zone context. Modification logs can support polling and cache invalidation but not semantic history without enum mapping.

### Calendar Events

- **Status:** Unsupported by Local API `1.0`.
- **Read/write endpoints:** none in the OpenAPI document.
- **Limitations:** no Calendar Event schemas or operations for dates, recurrence, reminders, location, or Associated Thought.
- **Design impact:** do not promise Calendar Event automation in the MVP. Historical dates remain in Notes/Thoughts unless a separate supported integration is approved.

### BrainBox

- **Status:** Unsupported by Local API `1.0`.
- **Read/write endpoints:** none in the OpenAPI document.
- **Limitations:** the desktop application contains internal BrainBox UI behavior, but it is not exposed as a supported Local API contract.
- **Design impact:** CRO capture must target Thoughts, Notes, attachments, and Tags directly rather than use BrainBox.

### Search

- **Status:** Supported with limitations.
- **Endpoints:**
  - `GET /api/search/{brainId}`
  - `GET /api/search/accessible`
  - `GET /api/search/public`
- **Required parameters:** `queryText` and `maxResults`; optional `onlySearchThoughtNames`. Public search also accepts `excludeBrainIds`.
- **Verified behavior:** Brain-scoped and all-accessible-Brains Thought-name search; public search with exclusion; attachment-filename search. Results can carry a Thought, link, attachment ID, result type, source/entity type, and cross-Brain provenance.
- **Limitations:** no documented filters for Types, Tags, dates, or graph scope. The API does not claim semantic/vector search. A newly written Note body was not found. Some attachment search results contained placeholder Thought timestamps and zero-valued Brain IDs even though the source Thought ID was valid.
- **Design impact:** treat search results as candidates, then hydrate by native Thought/attachment IDs. Combine name/content search with explicit graph traversal and Note reads.

### Bulk Operations and Notifications

- **Status:** Unsupported for writes; polling support exists for changes.
- **Bulk endpoints:** none. The OpenAPI document exposes only single-entity create, patch, and delete operations.
- **Change polling:** Brain and Thought modification-log endpoints can act as cursors when polled by time and count.
- **Limitations:** no transaction, batch request, atomic multi-entity write, webhook, server-sent event, or documented modification cursor token.
- **Design impact:** CRO must use per-operation idempotency, bounded concurrency, checkpointed jobs, compensating actions, and explicit partial-completion reporting. It must never claim atomicity across a capture that creates several TheBrain entities.

### Additional Brain-Lifecycle Finding

- `POST /api/brains` successfully created the isolated test Brain.
- `DELETE /api/brains/{id}` returned HTTP 200 with an empty object, but repeated list and direct-detail reads showed that the Brain still existed.
- CRO does not need Brain creation or deletion for its MVP. These operations should remain outside the CRO tool surface, and successful HTTP status alone must never be treated as proof of destructive completion.

## OB1 / Open Brain

**Discovery status:** Exercised through the live Open Brain connector on 2026-10-11.

**Available tools:**

- `open_brain_capture_thought`
- `open_brain_fetch`
- `open_brain_search_thoughts`
- `open_brain_search`
- `open_brain_list_thoughts`
- `open_brain_thought_stats`

**Test isolation:** One truthful `person_note` was captured with token `CRO-OB1-DISCOVERY-20261011`. Repeating the exact capture reused thought ID `fca02e5f-519d-40d1-b9a0-4af62ecd16db` rather than creating a second record. OB1 exposes no delete tool, so that single record remains.

### Summary

| Capability | Status | Read | Write | CRO consequence |
|---|---|---:|---:|---|
| Capture/create thought | Supported with limitations | N/A | Yes | Capture is simple, but no ID is returned directly |
| Fetch by ID | Supported | Yes | No | Provides the richest authoritative record |
| Semantic search | Supported with limitations | Yes | No | Scores and metadata are returned, but IDs are omitted |
| Filter/search by type | Supported | Yes | No | Exact metadata filter through recent-list tool |
| Filter/search by topic | Supported with limitations | Yes | No | Exact and case-sensitive, not semantic |
| Filter/search by person | Supported | Yes | No | Exact metadata filter |
| Date/time filtering | Supported with limitations | Yes | No | Relative `days` only; no absolute range |
| List recent thoughts | Supported with limitations | Yes | No | Recent-first output, but no IDs or pagination cursor |
| Update/edit | Unsupported explicitly | No | No | Exact duplicate capture behaves as an implicit metadata upsert |
| Delete | Unsupported | No | No | CRO cannot provide cleanup or correction through this connector |
| Capture metadata | Supported with limitations | N/A | Generated automatically | Immediate result omits ID and timestamps |
| Embeddings/search behavior | Supported with limitations | Yes | Automatic | Server-managed vectors; no vector access or model/version metadata |
| Five thought classes | Supported | Yes | Inferred on capture | Type cannot be explicitly selected during capture |
| Pagination/result limits | Limited | Yes | N/A | `limit` only; no cursor/offset and maximum is unclear |
| Duplicate handling | Supported for exact content | Yes | Automatic | Exact repeats reuse an ID and refresh metadata |
| Timestamps | Supported | Yes | Automatic | Full UTC timestamps only appear on fetch |
| Provenance/source | Supported with limitations | Yes | Automatic | Fetch returned `source: mcp`; callers cannot supply provenance fields |
| Relationships/linking | Unsupported | No | No | Topics and people are metadata facets, not navigable links |
| Bulk operations/transactions | Unsupported | No | No | Capture is one thought per call with no transaction boundary |

### Capture and Create

- **Status:** Supported with limitations.
- **Tool:** `open_brain_capture_thought`.
- **Required parameters:** `content` string only.
- **Verified behavior:** created a new thought, generated an embedding, inferred metadata, and made the thought immediately available to list and search operations.
- **Immediate return:** a formatted confirmation containing inferred class, topics, and people.
- **Not returned:** thought ID, URL, timestamps, source/provenance, action items, dates mentioned, embedding, or duplicate/upsert indication.
- **Limitations:** callers cannot explicitly supply type, topics, people, source, timestamp, relationships, or an idempotency key.
- **Design impact:** `capture()` can use OB1 for clear ideas, observations, tasks, references, and person notes, but CRO cannot reliably return the persisted ID without a follow-up compatibility search. Ambiguous post-capture ID resolution must be reported rather than guessed.

### Fetch by ID

- **Status:** Supported.
- **Tool:** `open_brain_fetch`.
- **Required parameters:** `id` string obtained from compatibility search.
- **Returned fields:** `id`, truncated display `title`, full `text`, synthetic `url`, and metadata.
- **Returned metadata:** `type`, `people`, `source`, `topics`, `action_items`, `dates_mentioned`, `created_at`, and `updated_at`.
- **Limitations:** semantic search and recent listing do not expose IDs, so fetch depends on `open_brain_search` or a previously known ID.
- **Design impact:** fetch is the authoritative hydration step after ID-bearing search. CRO should not treat formatted list/search snippets as complete records.

### Semantic Search

- **Status:** Supported with limitations.
- **Primary tool:** `open_brain_search_thoughts`.
- **Required parameters:** `query`; optional `limit` and `threshold`.
- **Returned data:** formatted ranked results with percentage match, captured date, type, topics, people, optional action items, and full thought text.
- **Verified behavior:** `limit` constrained result count; higher `threshold` removed lower-scoring results; a `0.99` threshold returned no result even for a query containing the test thought's unique token because its reported match was 61.2%.
- **Limitations:** no IDs, URLs, raw embeddings, distance metric, embedding model/version, pagination cursor, or structured result object are exposed.
- **Design impact:** semantic results are suitable for context packets but cannot directly drive fetch, update, or stable citations. CRO should preserve the displayed score as advisory and avoid aggressive thresholds.
- **Reconfirmed 2026-10-15 against the user's real OB1 data (91 thoughts):** relevance scores are soft signals, not a reliable cutoff — a reasonable-sounding threshold can discard genuinely relevant results. CRO should rank and present candidates rather than gate them on a fixed score.

### ID-Bearing Compatibility Search

- **Status:** Supported with limitations.
- **Tool:** `open_brain_search`.
- **Required parameters:** `query` only.
- **Returned data:** a JSON string containing `results`, each with `id`, truncated `title`, and synthetic `url`.
- **Verified behavior:** a unique token query returned the new thought and an older semantically related CRO thought. A broader `publishing workflow` query returned no results even though semantic search returned three matches.
- **Limitations:** no scores, full text, type, topics, people, timestamps, filter parameters, threshold, or result-limit control.
- **Design impact:** this tool is necessary to obtain IDs but is not a substitute for semantic search. CRO may need a two-stage search-and-fetch workflow and must handle cases where semantic and compatibility results cannot be matched unambiguously.
- **Reconfirmed 2026-10-15 against real data:** getting a stable ID and the ranked/scored text for the same thought requires two separate calls (`open_brain_search` for the ID, `open_brain_search_thoughts` for the ranked text) — there is no single call that returns both.

### Type, Topic, Person, and Date Filters

- **Status:** Supported with limitations.
- **Tool:** `open_brain_list_thoughts`.
- **Parameters:** optional `type`, `topic`, `person`, `days`, and `limit`.
- **Verified behavior:**
  - `type=task` and each other supported class returned matching records.
  - `topic=publishing` returned only thoughts carrying that topic.
  - `person=Keith Barrows` returned matching person metadata.
  - `days=1` returned the newly captured thought; `days=10` previously returned no thoughts.
  - Combining `type`, `topic`, `person`, and `days` returned the test thought, consistent with AND behavior.
- **Limitations:** topic matching was case-sensitive (`Discovery` matched; `discovery` did not). An invalid type returned an empty result rather than a validation error. Date filtering supports only “last N days”; no start/end timestamps, before/after, timezone, or sort parameter is exposed.
- **Design impact:** normalize or resolve exact topic/person values before filtering. Treat an empty result as “no match or invalid filter,” not proof that the class is valid. Absolute temporal queries require broader listing/search followed by client-side filtering of fetched records.

### Recent Listing and Statistics

- **Status:** Supported with limitations.
- **Tools:** `open_brain_list_thoughts` and `open_brain_thought_stats`.
- **Recent-list return:** date, type, topics, people when present, and full thought text in recent-first order.
- **Statistics return:** total thought count, overall date range, counts by type, top topics, and people mentioned.
- **Limitations:** neither output includes thought IDs. Recent listing exposes no cursor, offset, total count, or explicit sort control.
- **Design impact:** use recent listing for review and context, statistics for health/discovery, and compatibility search plus fetch when stable identity is required.

### Update and Edit

- **Status:** Unsupported explicitly.
- **Available tools:** none for arbitrary content or metadata updates.
- **Observed duplicate behavior:** capturing the exact same content twice kept the original ID, changed inferred topic labels, and advanced `updated_at`. Total thought count increased by one for the first capture and did not increase for the duplicate.
- **Interpretation:** exact-content duplicate capture behaves as an implicit upsert or metadata reprocessing operation. This is an inference from the observed ID, count, and timestamps; no explicit deduplication contract is exposed.
- **Limitations:** there is no way to correct text, change type, edit topics/people, attach provenance, or intentionally trigger reprocessing by ID.
- **Design impact:** CRO should treat captured OB1 text as append-oriented and user-visible. Corrections require a new thought or manual OB1 maintenance until an update tool exists.

### Deletion

- **Status:** Unsupported.
- **Available tools:** none.
- **Limitations:** CRO cannot remove accidental captures, duplicates, stale test data, or sensitive content through this connector.
- **Design impact:** confirmation thresholds for OB1 writes should be stricter than for reversible runtime state. CRO must never promise automated rollback of an OB1 capture.

### Capture Metadata, Embeddings, and Timestamps

- **Status:** Supported with limitations.
- **Generated metadata:** type, topics, people, action items, dates mentioned, source, created timestamp, and updated timestamp.
- **Capture response:** exposes only inferred type, topics, and people in formatted text.
- **Fetch response:** exposes the full metadata object. The test record returned `source: mcp` and UTC timestamps with explicit `+00:00` offsets.
- **Embedding behavior:** capture automatically generated a server-side embedding; semantic search returned match percentages and responded to a threshold. Raw vectors, embedding dimensions, model/version, re-embedding controls, and distance metric are not exposed.
- **Design impact:** CRO may rely on semantic retrieval but should record that ranking is opaque and can change after metadata reprocessing. Native OB1 timestamps should remain authoritative rather than being duplicated in CRO.

### Supported Thought Classes

- **Status:** Supported for all five documented classes.
- **Verified classes:**
  - `observation` — existing records and type filter verified
  - `task` — existing records and type filter verified
  - `idea` — existing records and type filter verified
  - `reference` — existing records and type filter verified
  - `person_note` — live capture, type filter, search, stats, and fetch verified
- **Write behavior:** class is inferred from content. `open_brain_capture_thought` has no type parameter.
- **Limitations:** classification cannot be forced or corrected through the connector.
- **Design impact:** prompts should make intended thought shape explicit, but CRO must report the actual inferred class returned by capture.
- **Reconfirmed 2026-10-15 against real data:** inferred classification skews heavily toward `observation` in practice. CRO should not use OB1's own type field to drive routing decisions — it is not a reliable classifier for CRO's purposes.

### Pagination and Result Limits

- **Status:** Limited.
- **Supported controls:** `limit` on `open_brain_list_thoughts` and `open_brain_search_thoughts`; `threshold` on semantic search.
- **Verified limits:** values of 1, 3, 5, and 10 behaved as requested.
- **Unsupported controls:** cursor, page, offset, continuation token, sort direction, and total result count.
- **Unclear:** maximum accepted `limit`, backend hard cap, and deterministic ordering for equally scored semantic results.
- **Design impact:** MVP retrieval must use small bounded result sets and cannot promise exhaustive traversal of the OB1 corpus.

### Duplicate Handling

- **Status:** Supported for exact-content duplicates; unclear for near-duplicates.
- **Verified behavior:** an exact second capture reused the original ID, retained one record in stats/listing, recomputed topics, and updated `updated_at`.
- **Not exposed:** duplicate-match reason, content hash, canonical ID in the capture response, or configurable merge policy.
- **Design impact:** exact retry appears safe, but CRO still needs its own short-lived idempotency record around uncertain connector failures. Near-duplicate detection requires semantic search and user judgment.
- **Reconfirmed 2026-10-15 against real data:** OB1 does not deduplicate across person/topic facets — the same real-world person or topic can end up represented by multiple distinct facet values rather than one canonical value. CRO's own capture/retrieval design must not assume OB1-side facet values are already deduplicated.

### Provenance and Relationships

- **Provenance status:** Supported with limitations. Fetch exposes an automatically assigned `source` field; the live capture returned `source: mcp`.
- **Caller-supplied provenance:** unsupported. Capture accepts only content.
- **Relationship status:** unsupported. No create, read, or traverse relationship/link tool is exposed.
- **Metadata facets:** topics and people provide lightweight retrieval facets but are not independently addressable graph nodes.
- **Design impact:** include source citations and project references in the thought text when they matter. Durable navigable relationships belong in TheBrain or the project repo, not OB1.

### Bulk Operations and Transactions

- **Status:** Unsupported.
- **Available operations:** one thought per capture and one ID per fetch.
- **Limitations:** no bulk create/fetch, transaction, rollback, webhook, change feed, or cursor-based export tool.
- **Design impact:** CRO must bound concurrency, checkpoint multi-thought work, report partial completion, and avoid workflows that require atomic OB1 writes.

## Repository adapter

**Discovery status:** Exercised against the live CRO repository and isolated Git fixtures on Windows with Git `2.45.2.windows.1` and ripgrep `15.2.0` on 2026-10-11. Fixture repositories covered ignored files, staged and unstaged changes, deletion, untracked files, detached and unborn HEADs, nested repositories, a local submodule, and a directory junction. Temporary fixtures were removed after discovery.

### Summary

| Capability | Status | Read | Write | CRO consequence |
|---|---|---:|---:|---|
| Repository-root identification | Supported with limitations | Yes | No | Git roots are deterministic; non-Git roots require explicit configuration or a supplied path |
| Git branch/commit awareness | Supported | Yes | No | Detached and unborn states must be modeled explicitly |
| Changed/new/deleted detection | Supported | Yes | No | Use porcelain v2 with NUL-delimited output, including index and worktree status |
| `.gitignore` handling | Supported | Yes | No | Enumerate with Git and retain the matching rule when explaining exclusions |
| Text/code/document artifacts | Supported with limitations | Yes | Deferred | Plain text is directly readable; binary document content needs a format-specific extractor |
| Explicit reference parsing | Supported with limitations | Yes | No | Paths and declared fields are deterministic; free-form names need project conventions |
| Project/artifact identification | Supported with limitations | Yes | No | Supplied path and declarations are reliable; multi-project inference can remain ambiguous |
| Cross-file reference resolution | Supported with limitations | Yes | No | Relative paths are resolvable; symbolic identifiers require a declared namespace or index |
| Incremental indexing inputs | Supported | Yes | No | Git provides commit and dirty-state deltas; non-Git sources require snapshot/hash comparison |
| Binary/large/generated safety | Supported with policy limits | Yes | No | Preflight size/type and honor ignores; do not parse arbitrary binaries in the repository adapter |
| Multi-project repositories | Unclear without conventions | Yes | No | Require configured markers or skill/artifact context rather than guessing |
| Symlinks and junctions | Supported with limitations | Yes | No | Detect but do not follow by default; resolve final targets and enforce root containment |
| Nested repositories/submodules | Supported with limitations | Yes | No | Treat nested repos as separate owners and submodules as pinned repository references |
| Windows canonical paths | Supported with limitations | Yes | No | Normalize absolute paths and case; junction targets and long-path policy need explicit handling |
| Content hashing/change detection | Supported | Yes | No | Hash working bytes separately from Git index objects and revalidate before hydration |
| Repo-grounded retrieval | Supported by derived index | Yes | No | Store chunks, hashes, paths, and IDs only; fetch the live file before final use |
| Skill declaration parsing | Supported with schema work remaining | Yes | No | The `cro_context` location is decided; validation details remain an implementation contract |
| Approved project writes | Deferred from MVP discovery | N/A | Technically available | Require separate format-specific validation, confirmation, atomic-write, and Git-safety design |

### Repository Root and Git Identity

- **Primary operations:** `git rev-parse --show-toplevel`, `git rev-parse --is-inside-work-tree`, `git rev-parse HEAD`, `git branch --show-current`, and `git status --porcelain=v2 --branch -z`.
- **Verified behavior:** commands run from a normal subdirectory resolved the containing repository. A nested repository resolved to its own deepest root. A true non-Git directory returned exit code `128`.
- **Important edge case:** Git walks up parent directories. A directory that is not itself a repository can still resolve to an ancestor repository, so CRO must check that a supplied artifact is contained by the intended canonical root rather than equating “Git returned a root” with “this directory is an independent project.”
- **Detached HEAD:** `branch --show-current` returned an empty string while `rev-parse HEAD` remained valid.
- **Unborn repository:** the branch name was available, but `rev-parse HEAD` returned exit code `128` because no commit existed.
- **Design impact:** model branch as optional, commit as optional for unborn/non-Git sources, and repository identity as canonical normalized root plus source kind. Do not infer a non-Git root without an explicit configured or supplied boundary.

### Working-Tree Changes and Ignore Rules

- **Primary operations:** `git status --porcelain=v2 -z --branch --untracked-files=all`, `git diff --name-status -z`, `git diff --cached --name-status -z`, `git ls-files -z --cached --others --exclude-standard`, and `git check-ignore -v -z --stdin`.
- **Verified behavior:** the fixture independently reported a staged addition, unstaged deletion, unstaged modification, and untracked file. Porcelain v2 preserved separate index/worktree state. Deleted paths remained discoverable even though their files no longer existed.
- **Ignore behavior:** ignored files were excluded from normal enumeration, and `check-ignore -v` identified the exact `.gitignore` rule. A tracked file remains tracked even if a later ignore rule matches it.
- **Limitations:** rename/copy classification is heuristic and may vary with Git configuration; path parsing is unsafe if line-delimited output is used with unusual filenames.
- **Design impact:** parse NUL-delimited machine formats, preserve both staged and working-tree status, and treat Git as the authoritative enumerator for Git repositories. Index deletion tombstones rather than requiring deleted content to remain readable.

### Artifact Reading and Explicit References

- **Directly supported:** text and code files readable as bytes or decoded text after encoding detection, including Markdown, Mermaid, YAML, JSON, TOML, XML, source code, and configuration files.
- **Binary/container formats:** PDF, DOCX, images, archives, and similar files can be enumerated, identified, sized, and hashed, but semantic text extraction belongs to a restricted format-specific extractor rather than the repository adapter itself.
- **Verified repository sample:** the live repository contained Markdown, Mermaid, and configuration files. Twenty-three relative Markdown links were resolved against their containing files with no missing targets.
- **Verified fixture:** YAML frontmatter values and a relative Markdown link were identifiable and resolved deterministically.
- **Limitations:** Markdown links, explicit relative paths, and declared YAML/frontmatter fields are reliable. Free-form card names, prose references, wiki-link syntax, aliases, and generated identifiers require project-specific conventions or a symbol index. YAML should be parsed with a real parser rather than regex in runtime code.
- **Design impact:** support a conservative text allowlist first, retain encoding and line-ending metadata, and attach reference provenance: source file, field or link location, raw target, normalized target, and resolution status.

### Project and Artifact Resolution

- **Resolution precedence:** supplied artifact/path, active skill `cro_context` declaration, repository-local project markers/configuration, then bounded inference from nearby artifacts.
- **Supported behavior:** a supplied file path can be normalized, containment-checked, mapped to its repository root, and treated as the current artifact. Explicit skill and frontmatter declarations can narrow project identity.
- **Limitations:** no universal filesystem rule distinguishes projects in a monorepo. The live CRO repository has no active `PROJECT` value and no `src` project yet, demonstrating that repository identity does not imply a child-project identity.
- **Design impact:** multi-project resolution is configuration-driven. Ask only when multiple plausible projects remain after path, skill, and declared metadata are applied.

### Incremental Indexing and Hashing

- **Committed changes:** compare commit IDs and use Git tree/diff operations to enumerate added, modified, deleted, and type-changed paths.
- **Dirty changes:** combine porcelain v2 status with direct working-file reads. A dirty worktree must not be indexed as though it were the committed `HEAD` snapshot.
- **Untracked files:** enumerate through Git with standard excludes, then hash and index eligible content directly.
- **Non-Git sources:** no native change feed exists; use a bounded filesystem walk plus canonical path, size, modification metadata, and content hashes.
- **Hash behavior:** Git object IDs describe Git-filtered/index content and currently use SHA-1 in the tested repository. SHA-256 over working bytes provides an algorithm-explicit content fingerprint. These values are related but not interchangeable, especially with line-ending or clean/smudge filters.
- **Design impact:** record source kind, canonical relative path, commit when available, working-content hash, index object ID when useful, and indexing timestamp. Revalidate the live hash before returning cached chunks as current.

### Binary, Large, and Generated Files

- **Preflight controls:** path/extension policy, file size, file attributes, MIME or signature sniffing, NUL-byte detection, Git attributes when present, and ignore status.
- **Generated content:** honor `.gitignore` and configured exclusions by default. Do not assume every unignored build artifact is canonical.
- **Large/binary content:** retain metadata and hashes without loading the full file into a text pipeline. Route approved formats to bounded, sandboxed extractors with archive depth, decompressed-size, and entry-count limits.
- **Limitations:** no universal size threshold or generated-file taxonomy is encoded in Git. Git LFS pointers, if introduced, require separate detection and should not trigger an implicit network fetch.
- **Design impact:** the repository adapter discovers and classifies; specialized extractors produce inert text. Unsupported or oversized content remains a metadata-only candidate with an explicit reason.

### Nested Repositories, Submodules, and Links

- **Nested repositories:** a nested `.git` directory resolved as an independent repository; the parent reported the directory as one untracked repository entry rather than ordinary child files.
- **Submodules:** `.gitmodules` exposed path and URL, while the parent index stored the submodule as mode `160000` plus a pinned commit. This is sufficient for detection without recursively treating it as parent-owned content.
- **Junctions:** Windows exposed the reparse point and final target. `Resolve-Path` alone retained the junction path, so final-target resolution is required for containment checks.
- **Symbolic links:** creating a symlink required administrator privilege in the tested environment, and the repository has `core.symlinks=false`. Reading repositories that already contain Git mode `120000` entries remains a required adapter case, but live symlink traversal was not verified here.
- **Design impact:** do not follow reparse points by default. When explicitly allowed, resolve the final target, reject escapes outside configured roots, track visited file identities to prevent cycles, and keep the link path distinct from the target identity. Index nested repositories separately; represent submodules by parent path, URL, and pinned commit unless separately opened as an approved source.

### Windows Path Normalization

- **Verified behavior:** `System.IO.Path.GetFullPath` removed `.`/`..` segments; existence checks were case-insensitive; Git emitted repository paths with forward slashes while native APIs used backslashes.
- **Canonical form:** retain the normalized absolute root internally, but store repository-relative paths with `/` separators for Git interoperability. Compare Windows paths using ordinal case-insensitive semantics while preserving display casing.
- **Limitations:** final reparse targets require separate resolution. Long-path behavior depends on OS, process, and Git configuration and was not stress-tested.
- **Design impact:** reject paths that escape the canonical root after final-target resolution. Never use string-prefix checks without a separator-aware path containment test.

### Repo-Grounded Retrieval Boundary

- **Status:** Supported with a derived, rebuildable index.
- **Indexable data:** canonical repository/root ID, relative path, artifact type, selected metadata, explicit references, content chunks, hashes, commit/status metadata, and embeddings.
- **Authoritative data:** the live repository file and Git metadata, not the index copy.
- **Retrieval contract:** use exact/full-text, semantic, metadata, and explicit-reference signals to find candidates; re-check path containment and current hash; then read the live artifact before final use.
- **Design impact:** deleting `cro_index` loses search acceleration, not project truth. Repository writes remain outside the read-only MVP until format validation, approval boundaries, atomic replacement, conflict detection, and Git-state policy are designed and tested.

## Discovery completion criteria

Phase 0 capability discovery is complete. Its verified implementation boundary is:

1. Begin with read-only, repo-grounded context recall using conservative file policies and live hydration.
2. Use the local derived index only for candidate retrieval; keep repository files authoritative.
3. Treat TheBrain and OB1 limitations exactly as recorded above rather than emulating unsupported mutation behavior.
4. Keep repository writes, public ingress, Home Assistant, dashboards, backup automation, and local-AI integration outside the initial runtime scope.
5. Preserve idempotency, bounded operational state, explicit partial completion, local-only sensitive data, and source-native identifiers throughout implementation.
