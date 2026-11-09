# User Story 02 — Read Each Brain's Types

**Status:** Not started

**Story:** As the CRO developer, I want the resync to read `/thoughts/{brainId}/types` for every brain, so every Type is known before any Thought is read.

**Done when:** the call runs once for every brain returned in Story 01. Each brain's
Types come back as that brain's live list. A brain with no Types
returns an empty list and is not an error.
A Type is also a Thought (kind 2). Writing that Thought's own
`thebrain_nodes` row is Feature 02's job, not this story's.
