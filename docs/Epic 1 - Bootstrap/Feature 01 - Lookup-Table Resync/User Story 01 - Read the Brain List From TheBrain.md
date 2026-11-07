# User Story 01 — Read the Brain List From TheBrain

**Status:** Not started

**Story:** As the CRO developer, I want the resync to read TheBrain's `/brains` list, so `cro_index` knows which brains really exist.

**Done when:** a call with the token from User Secrets (`TheBrain:ApiToken`, never
printed or committed) returns every brain TheBrain lists, each with its
id and name. The test compares against the live list on the day, not a
fixed number.
