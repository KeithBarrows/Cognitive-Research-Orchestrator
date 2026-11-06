# User Story 07 — Capture and Search Work

**Status:** Done 2026-11-05

**Story:** As the CRO developer, I want to capture a thought and find
it again by meaning, so I know OB1's REST surface works.

**Done when:** One `POST /functions/v1/capture` returns
`{"ok":true,"id":...,"fingerprint":...}`, and one
`POST /functions/v1/search` returns that thought. `GET
/functions/v1/list` also works. The real request and response shapes
are recorded here.

**Notes:** Capture returns `{ok,id,fingerprint}`; search returns
`{ok,query,count,results[{id,content,metadata,similarity,
created_at}]}`; `list` returns `{ok,limit,offset,total,results}`.
Auth is the `apikey` and `Authorization: Bearer` headers with the
generated `ANON_KEY` (never printed or committed). Reworded searches
matched at similarity 0.545 and 0.731. The recipe has no update or
delete; Story 11 covers that. Test thoughts were removed afterward.
