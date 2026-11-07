# Notes and Findings

Keith's own findings, kept so they are not lost. These are NOT part of
any plan yet. Nothing here is decided. When a finding becomes real work,
move it into a Feature or User Story and leave a link here.

**Planned (Keith, 2026-11-07):** this file will eventually become a
scrum/kanban-style backlog of user stories. Entries here are the raw
material. Keep each idea in its own numbered part, with its status and
open questions, so it can be split into stories later.

Format: newest first. Each entry has a date, a source, and a status
(Unverified / Verified / Planned).

## 2026-11-07 — Categories, capture, outside-LLM boundary, and two capture pages (ideas)

**Source:** Keith, in a Q&A on 2026-11-07.
**Status:** Ideas and open questions. Nothing decided, nothing built.
Epic 3 (capture) has no screen yet; none of this is in a plan.

**1. How OB1 gets its category (checked).**
- The cloud OB1 asks a language model at save time for a small JSON
  block with a `type` (observation, task, reference, idea,
  person_note). That is the category. Its source is not in this repo;
  the model and prompt are unverified.
- The local OB1 has no such step. Its `capture` function only embeds the
  text and stores the `metadata` the caller sends. Without metadata
  there is no category.

**2. Categories are two questions.**
- **Kind of thing** (person, event, place, idea, task): a short, fixed
  list in CRO. Decided by rules from TheBrain (Type name, parent's
  Type), then embeddings compared to a short description per category,
  then an outside LLM for `standard` content only, else "unknown" and a
  flag for Keith.
- **Where it sits in the knowledge tree** (Animals > Mammals > Cats,
  ages, sciences): huge and growing, so no category table. The category
  is the ancestor path from `edges` (a recursive query), stored as text
  in OB1 `metadata`. A Thought with several parents has several paths;
  store the shortest and keep the rest in `edges`. Paths are built after
  Pass 1 has loaded all edges.
- Package options noted: ML.NET (needs labelled examples), FuzzySharp or
  F23.StringSimilarity (string matching only). Not recommended.

**3. "Save this URL" flow (Epic 3).**
1. Check whether the URL already exists (TheBrain looks attachments up
   by location). 2. Fetch the page and make a short summary and title.
3. Embed it and search `chunks` and OB1 for nearest Thoughts. 4. Attach
   to a close Thought's Note, or create a new Thought under a parent
   chosen from the neighbours' paths. 5. Always write to OB1.
- CRO proposes with the reason; Keith approves before anything is
  written to TheBrain. Auto-accept for high-confidence cases only later.
- Open: the "close enough" cutoff (needs real data); one parent or two
  when a Thought has several good homes.

**4. Outside LLM boundary (draft).** OpenRouter will be needed; the
laptop cannot run a model good enough locally (Keith, 2026-11-07).
- Nothing leaves the laptop unless CRO decided, locally, it is safe. The
  check cannot itself be an outside call.
- Signals: TheBrain's Private marker (`access_type = 1`) and whether the
  Thought is outside the private-home brain; local keyword rules; the
  embedding comparison; the existing tiers. Only `standard` may go out.
  `personal` and `restricted` never do.
- Default deny: if unsure, it stays home.
- Send the least that works (title and short excerpt for
  categorizing). Log what was sent, to which model, and when. Early
  versions show a preview first.
- Keith picks the model (a "use model" option).
- To check before any real content goes out: OpenRouter's current policy
  on provider data retention and training (believed to be restrictable;
  unverified).
- The 2026-11-05 decision allows `restricted` text in local OB1 because
  OB1 is inside the trusted boundary. OpenRouter crosses that boundary,
  so it needs its own decision.
- A public endpoint is a separate lock: listen on `127.0.0.1` only,
  every route (`/api`, `/mcp`, `/admin`) needs a key, no anonymous
  search or fetch, the key in User Secrets, nothing published to the
  internet. Opening a LAN port stays its own decision under the
  2026-10-17 home-network-only boundary.

**5. Capture page, filing wizard (idea).** A page under `/admin` where
Keith drops a file (example: next year's property tax report), picks
sensitivity (Private), the brain (Filing Cabinet) and types a
description, sees a review of what is saved where and what, if anything,
leaves the laptop, then confirms. CRO attaches the file in TheBrain,
writes the description to OB1 and indexes it. His choices beat any
guess: Private means no outside model ever sees it. Open: TheBrain's
file upload does not return the new attachment's id, so CRO re-reads the
Thought to find it; scanned PDFs and images need OCR or a vision model
(not designed).

**6. Capture page, quick parse (idea).** Drop a file or paste a large
text block and click [Send to LLM]. A local check runs first; a preview
shows size, estimated cost and the chosen model. The result goes to a
review screen (title, summary, kind, key facts, suggested home), never
straight into TheBrain; Keith saves, edits or discards. If the local
check flags the content, the button is blocked by default; Keith can
override per item with a deliberate extra click, and the override is
logged. There is no local-model option. Over-long text gets a "too big,
split it?" message, not a silent send. PDF text is extracted locally.

**When this becomes real work:** Epic 3 (new Features for the two pages
and the outside-LLM boundary), after Epic 1's publish Feature.

## 2026-11-07 — What TheBrain's /graph really returns (read-only check)

**Source:** a read-only check against the local TheBrain API
(`localhost:11522`) on this laptop: the Growth home Thought, then 120
Thoughts reached by walking outward.
**Status:** Verified for Growth, 120 Thoughts. Other brains not checked.

- **Shape.** Top level: `activeThought`, `parents`, `children`,
  `jumps`, `siblings`, `tags`, `type`, `links`, `attachments`. The
  neighbour lists hold full Thought objects, each with its own
  `brainId`. Link items hold `thoughtIdA`, `thoughtIdB`, `relation`,
  `meaning`, `direction`, `name`, `color`, `thickness`, `brainId`.
- **`relation`:** 1 is parent/child, 3 is jump. The 185 jumps seen match
  the 185 relation-3 links.
- **`meaning`** values seen: 1, 2, 5. **`direction`** values seen: -1, 1.
  Both undocumented; stored raw (`edges.link_meaning`,
  `edges.link_direction`, V005).
- **No cross-brain items.** All neighbours were in the same brain as
  their Thought. This fits Keith's idea that a jump to another brain is
  in the Note text as a `brain://` link, not in `/graph`. A strong hint
  from one brain, not proof.
- **Siblings are large:** 655 against 358 children. They can be worked
  out from parents and children, so the crawl should use
  `includeSiblings=false`.
- **Tags** are Thoughts of kind 4. One was seen.
- **Not checked:** the other 7 brains and Thoughts with very large
  graphs.

**When this becomes real work:** Epic 1 Feature 02, Pass 1.

## 2026-11-07 — The embedding model reads only 2,048 tokens; long Notes must be chunked

**Source:** Keith (large TheBrain Notes were discussed earlier), plus a
test on this laptop.
**Status:** Verified for the limit. Chunk size is a proposal.

- **Test (2026-11-07).** Ollama `nomic-embed-text` via `/api/embed`.
  Texts of 200, 1,000 and 1,500 words: the vector changed when a
  different paragraph was appended. Texts of 3,000, 4,000, 6,000 and
  10,000 words: tokens read stopped at 2,048 and the vector was
  identical with or without the appended paragraph (cosine 1.000). The
  model silently drops everything after 2,048 tokens. No error.
- **OB1 effect.** The local OB1 `capture` function sends the whole
  content in one call and has no length check. The full text is stored,
  but the vector covers only the first ~2,048 tokens. A search for
  something near the end of a long entry will not find it.
- **Limit of the test.** The test words were simple, 1 word = 1 token.
  Real prose is about 1.3 tokens per word, so the real cap is probably
  1,200-1,500 words. Chunk well under it anyway.
- **Proposed rules for bootstrap Pass 2** (Epic 1 Feature 02):
  1. Cut each Note and each file list into chunks of about 1,000-1,500
     characters, at natural breaks (paragraph, list item, file entry),
     not mid-sentence.
  2. One `chunks` row per piece, each with its own 768-dim vector.
  3. Start every chunk with the Thought's name, so a piece makes sense
     alone.
  4. OB1 keeps one entry per Thought with the full text (existing rule).
     Its vector is a broad match on the opening; `chunks` gives the
     precise match.
  5. Guard: if any text sent to OB1 or `chunks` is over the safe length,
     log it so nothing is cut silently.
- **Files** are not stored in OB1. Only their text descriptions are.

**When this becomes real work:** Feature 02, Pass 2 stories.

## 2026-11-06 — How the CRO app is reached: one address, paths, and what "listening" means

**Source:** Keith, plus a pasted Kestrel and Docker answer and checks on
this laptop.
**Status:** Partly verified (marked below). Nothing built yet.

- **One address, paths not subdomains.** CRO is one root address. The
  app routes by path: `/api`, `/mcp`, `/admin`. It runs the same in
  Visual Studio and on a server. Kestrel does not route by hostname;
  YARP or another proxy would be needed for that, and is not planned.
- **Hosts file.** It maps a name to an IP only. It has no ports and no
  wildcards. The port always goes in the URL. The desktop reaches the
  laptop as `cro.home.sol3.net` (hosts line, `192.168.9.250`).
- **`*.localhost`.** Browsers and curl resolve it to loopback
  themselves; Windows does not. Verified 2026-11-06: `ping
  cro.localhost` and .NET `Dns.GetHostAddresses` failed on this laptop;
  curl returned HTTP 200 from `127.0.0.1`. Keith states it works in
  .NET (not tested here). A `.localhost` address is loopback only:
  other computers cannot reach it.
- **Listening is set when the app is published.** Kestrel inside Docker
  listens on all container addresses (for example
  `ASPNETCORE_HTTP_PORTS=8080`). The compose `ports:` line decides who
  outside can reach it: `127.0.0.1:PORT:8080` is the laptop only;
  `PORT:8080` is every network the laptop joins, hotel Wi-Fi included.
  Pair the second with a Windows Firewall rule limited to the home
  subnet. Do not bind to `192.168.9.250`: it does not exist when
  traveling. Unverified: this comes from a pasted AI answer, not a test.
- **Host port is open.** `5000` was only an example. Port 8000 is OB1's;
  80 and 443 are reserved.

**When this becomes real work:** Epic 1 needs a Feature for publishing
the CRO app (port, listening, firewall). Move this entry there then.

## 2026-11-06 — CRO needs an in-depth health check and a health API endpoint

**Source:** Keith, after the first full reboot check.
**Status:** Unverified (nothing built yet; this is a need, not a plan).

CRO's future code base needs an in-depth health check, and an API
endpoint that exposes it. The check should cover every system CRO
depends on, not just "is the process up":

- Docker: each container running and healthy, restart counts, exit
  codes, disk use.
- `cro_index` Postgres: reachable, Flyway at the expected version,
  tables present, row counts sane.
- OB1 (Supabase stack + Ollama): API answers, database answers, the
  embedding model is loaded and returns a vector.
- Plane: API answers, workspace `cro` and project `CRO` exist.
- TheBrain: Local API answers with the token, all expected brains are
  listed, each home Thought is readable.

**Why it matters later:** after a reboot, a manual walk through Docker
and TheBrain took many separate commands. One endpoint (for example
`GET /health/deep`, next to the ping-only scaffold) could answer it in
one call and name exactly which part is down.

**Lessons from the first reboot check (2026-11-06):**

- Several containers restart a few times at boot (`supabase-auth` 10,
  `supabase-storage` 10, `supabase-pooler` 6, `realtime` 4, Plane api
  and workers 2). The logs show they tried to reach Postgres while it
  was still "starting up", then recovered. The check should tell
  "restarted at boot, now healthy" from "crash looping".
- A running container is not a healthy service. Check the real API and
  database behind each one.
- Keep a shallow check (fast, no secrets, for "is it alive") separate
  from the deep check (uses tokens, touches every system).

**To decide when the time comes:** whether the deep endpoint needs its
own auth; how long a deep check may take; whether results are cached.

## 2026-11-06 — TheBrain thoughts are tied to real folders

**Source:** Keith.
**Status:** Unverified (not yet checked against the TheBrain API).

Each TheBrain thought is married to a physical folder on the hard
drive. When saving links, files, images or videos and attaching them to
an existing thought, the TheBrain API should be able to return that
thought's physical folder path. Then CRO can save the file straight into
the correct folder, instead of guessing or asking.

**Why it matters later:** the capture flow ("please remember [link]")
could file attachments in the right place on its own.

**To check when the time comes:** which API call returns the folder
path; whether it works for thoughts that have no folder yet; whether
the path is the same one the file sync (Feature 05) sees.
