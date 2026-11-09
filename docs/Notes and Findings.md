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

## 2026-11-09 — How CRO handles new data while the old plex is messy: propose, then wait for Keith's yes (design discussion)

**Source:** Keith, 2026-11-09. The ideas marked "(Claude)" are Claude's
suggestions that Keith has not decided.
**Status:** Design thinking. Nothing decided beyond what is marked
"Keith". Nothing built.

**The problem (Keith)**
- The Growth brain grew in many unrelated ways and got so large that
  Keith quit using it. CRO must not repeat that.
- The base data is uneven. Reorganizing all the brains would take
  months, so CRO has to work around that until the data is cleaner.
- A branch cannot simply be moved to another brain, because the target
  brain may not yet have the right shape to take it. Moving whole
  trees to the right brain (leaving a jump link behind) is about how
  the data stores are organized, not about new data, and is a later job
  (Epic 4).
- Each brain Thought needs to be in CRO, but scraping alone is "not
  100% the right approach". The open question is how CRO handles **new**
  data.

**Keith's decisions**
- **No inbox.** An inbox makes the brain messier and "later never
  comes". CRO must always propose a concrete home, or propose creating
  one, at capture time.
- **Nothing is written to TheBrain until Keith says yes.**
- **The front end:** a local website and/or a skill. It takes text and
  files, evaluates them (an LLM is involved), suggests a few probable
  landing spots (a new Thought under X, a Note added to X, a target
  brain), and Keith answers "yes" or "change to Thought Y".
- **Both options are shown to Keith to choose** (new Thought versus
  Note) until his choices show a clear pattern about 99% of the time.
- Expectation: Keith is heavily involved at the start; CRO grows as the
  data grows, building the links between thoughts in a way that makes
  sense.
- **The plex is one large tag cloud across all brains** (Keith). Every
  Thought is a tag, a parent link is "tagged with", and a Thought can
  have several parents. Example: an AI built at home sits under
  Technology, then Computers, and also under AI. CRO should pick the
  most specific fitting Thoughts, several of them, and the broader
  parents come from the graph. "Computers" existing in more than one
  brain is not a concern; a brain may hold a few sub-thoughts that
  link to the brain where most of that subject lives.
- **Feature 02 Story 07** (not yet written) is to be an **ancestor
  set**, not a single path: every Thought stores all its ancestors,
  built from parent links inside one brain; jumps and links to other
  brains are not followed; one shortest path is kept for display. It
  needs a small migration for a `thebrain_ancestors` table, shown to
  Keith before it is applied.

**Ideas (Claude), not decided**
- The pending item waits in `cro_index`, not in TheBrain: it is saved
  and searchable at once, and TheBrain holds no unplaced junk.
- Both the website and the skill sit over one CRO. CRO keeps each
  proposal as a record (input, suggested spots, status), so a yes from
  either front end is the same action.
- Show each suggestion as a full path (Brain > Parent > Thought) so
  "change to Y" is unambiguous when titles repeat.
- Log each suggestion and Keith's answer. Epic 1 Feature 08 already
  plans a rebuild-safe store for his decisions; this could feed it.
  Counts per kind of input would show when a default is earned. A
  default only pre-selects an option; it never skips asking.
- Placing new items next to their nearest old neighbours copies the old
  mess forward. Keith could mark a few branches as the shape he wants
  (for example Author > Writing), and CRO would prefer those as targets
  and only search the legacy areas.
- When the right home does not exist (for example "Writing with AI"
  under Writing), CRO proposes creating it and Keith approves.
- A search rule: follow links to another brain one hop, so a Growth
  "Computers" query reaches the brain where most of it lives.
- Files: TheBrain's upload does not return the new attachment's id, so
  CRO re-reads the Thought to find it.
- The privacy gate matters mostly on the website path, where text goes
  to OpenRouter.

**A hard case read on 2026-11-09 ("Technologist & ASPInsider" in
Growth, read-only).** Created 2012, changed 2017. No Note, no tags, no
Type. Two parents ("Who I Am" and "Computers & Technology"), two jumps
("Computer sciences", "The Developer"), three attachments (an icon and
two Word documents). Ten children with about 56 grandchildren at the
second level: ASPInsiders material (Official Home, Perks, Summits),
three "(Quiver)" branches that look imported (My Tools, Software
Development, OS Management), and lists (Big Topics, Tech Blogs, Trends,
My Projects). It mixes program membership, software knowledge and
planning lists under one title. Idea (Claude): flag such a Thought as a
candidate to split into two Thoughts that link to each other, in
Epic 4.

**When this becomes real work:** Epic 3 (the proposal flow and its two
front ends), Epic 4 (moving trees, splitting Thoughts), and Epic 1
Feature 02 (Story 07).

## 2026-11-09 — Worked example (a person from a URL), the transcripts folder, and pers-research as ingest sources (ideas)

**Source:** Keith, 2026-11-09; a read of the author page Keith
supplied; a read-only scan of `D:\Repos\pers-research` on this laptop.
**Status:** Observations are verified as read. The CRO behavior is an
idea, not decided.

**Keith's expectation.** He expects to be involved more at the start.
CRO should grow as the data grows, building the links between thoughts
in a way that makes sense. One purpose: shuffle scattered material (the
YouTube transcripts, the whole `pers-research` repo) into CRO, so
unrelated data is not lost for lack of one solid place to keep it.
`pers-research` should not be a repo; it should live in CRO.

**Worked example: "save this URL" for a person.**
- URL: `americanmind.org/author/jennica-pounds/`. The page states: Jennica
  Pounds, "a data analyst and the co-author of *Unelected*"; "She writes
  as @DataRepublican on X" (link `x.com/DataRepublican`); four recent
  articles. It does not mention her being deaf, a DOGE job, or USAID;
  those are Keith's knowledge and must be marked as his, not sourced.
- Keith: DataRepublican is a very public figure, so the entry is
  `standard`. **`personal` applies only to Keith and his family
  members** (health, tax and financials mainly). The schema doc still
  says the exact bar for `personal` is "still to define"; not yet
  updated.
- Idea: one TheBrain Thought (alias "DataRepublican" in its `aliases`
  field; the source URL, X link and article URLs attached or linked) and
  one short OB1 `person_note` entry. TheBrain Thoughts have an `aliases`
  field; whether name lookup matches an alias is untested.
- **CRO should suggest the parent** (Keith: "that is part of what I want
  CRO to suggest"): read the page, check for an existing Thought by
  name, alias and URL, propose ranked parents from the nearest Thoughts
  and their ancestor paths (several parents are allowed), show the
  reason, and write only after Keith approves.

**Search ("did I save anything about DataRepublican?").** Tested the
embedding model on a rare name: a spaced variant scored 0.68, a URL with
the name 0.64, a related topic without the name 0.55, "Republican party
politics" 0.48, unrelated 0.37 (invented test texts). Gaps are small, so
vectors alone are weak for names. A good search blends meaning, exact
words, fuzzy spelling (`pg_trgm`, available but not installed in
`cro_index`), filters by subject and path, and the graph. Gaps in the
current plan: saved URLs are TheBrain attachments (name and location)
and have no chunk; the title chunk should include aliases; a transcript
saved as a file is not searchable unless its text becomes a Note.

**The transcripts folder.** The `youtube-transcript-pull` skill in
`.ai-config` writes to `D:\Repos\pers-research\.transcripts\youtube\
<channel>\<title>-<videoid>\` with `info.md` (title, channel, URL,
upload date), `transcript.md` and `transcript-timed.md`. The folder is
in `pers-research`'s `.gitignore`, so it was never in git; Keith copied
it from the desktop to this laptop on 2026-11-09. Scan: 40 videos in 25
channel folders, 1.9 MB, plus 2 `.zip`, 2 `.srt` and 1 `.vtt` strays.
Transcript size: 552 to 55,392 characters, median about 11,200; 24 of 40
are over the embedding limit (about 8,000 characters). About 400 chunks
at 1,200 characters. Many are YouTube Shorts with under 2,000
characters. The timed file is mostly a duplicate. Channels seen include
AI-for-writing (The Nerdy Novelist, Nail It With AI, Future Fiction
Academy, Bookfox), AI tools and news, space and science (ASTRO
ALEXANDRA, Thomas Mulligan), property tax and real estate (Epic Real
Estate, Retirement Guard, Daniel Archer), and history (Atlas of
Civilizations).

**`pers-research` (150 files, 78 MB, one repo).** Top-level folders:
Artificial Intelligence, Family, Homesteading, Legacy, Longevity,
Politics, Purpose, Science Fiction, Social, Technology, The Future of
Humanity, Transhumanism, World History. Includes
`Politics/DataRepublican/Starting Point.md`. These may be where Keith's
subjects live today; to confirm with Keith.

**Note on the 2026-10-22 decision.** "CRO never reads a repository
directly" is about retrieval. Moving this material into CRO is ingest,
a different thing. Keep the two apart.

**When this becomes real work:** Epic 3 (capture, the suggestion flow)
and Epic 5 or a new ingest Feature for the transcripts and
`pers-research`; chunk and attachment additions in Epic 1 Feature 02.

## 2026-11-09 — What OB1 is for, and where it fits CRO (Q&A, nothing decided)

**Source:** Keith's Q&A on 2026-11-09; Nate B. Jones's published posts
and guides (read through the Nate's Library connection); and the OB1
repo fork on this laptop (`D:\Repos\KeithBarrows\OB1`, HEAD `238df6c`).
**Status:** Findings from the sources are verified as read. The design
ideas are Keith's thinking and mine, not decided.

**What the sources say**
- Posts read: "Why your AI starts from zero every time you open a new
  chat" (2026-03-02, read in full) and "You built an AI memory system.
  Now your agent needs hands" (2026-03-13, first 20,000 of 28,324
  characters). Guides read: "Open Brain: one memory for every AI" and
  the Taste Preferences extension guide (first 5,000 characters).
- OB1 is shared memory for AI tools: your role, projects, people and
  decisions, so no new chat starts from zero. A captured thought is
  stored as text, a vector, and extracted metadata (people, topics,
  type, action items), and searched by meaning. Nate says the metadata
  is imperfect and the embeddings do the heavy lifting.
- The household, maintenance, calendar, meal and contact tables are
  optional extensions, each a separate table. Nate's own rule: the
  `thoughts` table is a stream; anything structured is a registry in
  its own table.
- Code in the fork (`integrations/rest-api/_shared/config.ts`,
  `helpers.ts`): the classifier prompt begins "You classify personal
  notes for a second-brain." Types: idea, task, person_note, reference,
  decision, lesson, meeting, journal. It scores importance 0-6 and
  confidence 0-1, and rates general knowledge low ("reads more like
  general knowledge than personal context"; below 0.5 is "encyclopedia-
  grade facts"). Metadata also carries `topics` (1-3 short tags),
  `tags`, `people` and a sensitivity tier (default `standard`). Text
  over 30,000 characters logs a warning to route it through smart-ingest
  for atomization, meaning split into several thoughts.
- The local OB1 install in `src/Infra/03a-ob1-local-brain` has none of
  this classification: its `capture` only embeds the text and stores the
  metadata the caller sends.

**Keith's design thinking (not decided)**
- `cro_index` may become the master index. Some Brain Thoughts belong in
  OB1 and some do not. OB1's natural query was meant to be the search
  entry point, followed by a focused search in `cro_index`.
- The line for what goes to OB1 is by subject (writing, homesteading,
  marriage, health, finances), and a subject can cross two or more
  brains. General-interest trees (animal kingdom, science, ages,
  history) are structure and belong in TheBrain and `cro_index`.
- Pushback raised: "Thoughts with Notes always go to OB1" may flood OB1
  with general knowledge that its own scoring rates low, and drown
  personal memories. The OB1 `topics` field is a possible carrier for
  the subject. An OB1-first search cannot find Thoughts that are not in
  OB1, so every Thought would also need its title and ancestor path
  searchable in `cro_index`.
- The 2026-11-05 rule (every TheBrain Thought links to an OB1 node) still
  stands; nothing has replaced it.
- Open: where a subject lives in TheBrain today (a Thought each brain
  has, a Type, a tag, or only in Keith's head). Not yet answered.

**When this becomes real work:** Epic 1 Feature 02 (which Thoughts go to
OB1, Story 05) and Epic 2 (search order).

## 2026-11-09 — Make AI follow very large instruction sets for fiction writing (backlog)

**Source:** Keith, 2026-11-09: "Need to explore how to have AI follow
very large instruction sets for fiction writing as that is where I am
frustrated the most!"
**Status:** Backlog, to explore later. Nothing investigated. Raw note.

- Related to the entry directly below ("Rules read at startup do not
  stay bound"): the same loss of rules as the context grows is likely
  worse when the instruction set is very large, as fiction rules are.
  That link is an assumption, not tested.
- Open questions for Keith when this is picked up: what exactly goes
  wrong (voice drift, forgotten canon, ignored rules, drifting style over
  a long chapter); which instruction files are involved and how large
  they are; whether the failures appear mid-session, after a
  compaction, or at the start.
- Possible directions to evaluate, none tried: enforcement or checking
  after the fact instead of relying on memory; loading only the rules
  needed for the current scene; a tool that returns the rules in force
  at the moment of use (see the CRO tie-in in the entry below).

**When this becomes real work:** to be decided; it may be a CRO Feature
(rules and canon served at point of use) or a separate writing-workflow
project.

## 2026-11-09 — Rules read at startup do not stay bound; investigate how to keep them in force (backlog)

**Source:** Keith, 2026-11-09, after two misses in one session.
**Status:** Backlog, to investigate later. Nothing built. The hook
names and behavior below are believed, not verified.

- **The problem (Keith).** Rules the AI is told to read at startup get
  pushed out of effect as the context grows. No AI has a mechanism that
  keeps a ruleset always bound.
- **Evidence from this session.** After a context compaction the ELI5
  answer style was dropped until Keith pointed it out. The cloud OB1 was
  cited as a source after Keith's rule to ignore it. Earlier "saved as a
  standing rule" promises could not be shown to exist: the project's
  memory folder had no index file until 2026-11-09.
- **What probably happens.** Startup text stays in context but is
  followed less reliably as the session grows. A compaction summary keeps
  what mattered to that conversation, so rules get compressed or
  dropped. Not verified.
- **Mechanisms that do not depend on the AI remembering** (the harness
  runs them; check the Claude Code docs before building):
  1. **Enforcement.** A deny rule or a blocking hook cannot be
     forgotten. Example: deny every `mcp__open-brain__*` tool so the
     cloud OB1 cannot be called. Fits hard rules a program can check
     (approval gates, commit only when told).
  2. **A short rules digest injected on every turn** (about 10 lines),
     near the end of the context, where it is followed best. Costs
     tokens each turn, so it must stay small. Improves compliance;
     does not guarantee it.
  3. **Re-injection when a session resumes or compacts**, so a summary
     cannot drop the startup rules.
- **Proposed split.** Hard rules go to enforcement. Soft rules (ELI5,
  one recommendation, short answers) go to the digest. Only enforcement
  is a guarantee, and it cannot cover style rules.
- **CRO tie-ins.** A tool that returns "the rules in force right now" at
  the moment of use beats a startup read. This is a reason to promote
  the optional local OB1 MCP wrapper (Feature 02) from "optional" to
  "wanted, for shared rules and memory", and fits Epic 6 (skill hooks).
  Today the local OB1 has no MCP connection, so rules live in repo files
  (`CURRENT.md` Non-negotiables) and in the AI tool's own memory.
- **Standing rule recorded 2026-11-09.** Never use the cloud OB1 as a
  source unless Keith asks; CRO is a 100% local build. Held in the AI
  tool's memory and still to be added to `CURRENT.md`.
- **Open questions.** Exact hook events and their limits. How large a
  digest can be before it costs more than it helps. Whether CLAUDE.md
  and startup files are re-read after a compaction. Which rules in
  `D:\Repos\.ai-config` are hard enough to enforce.

**When this becomes real work:** a Feature under Epic 6, or an Epic 0
style setup task for the hooks, once Keith decides.

## 2026-11-09 — Moving a Thought between brains is a copy, and the copy's id can be computed

**Source:** Keith's copy/paste of three test Thoughts ("Move Test",
"Move Test 2", "Move Test 3") from Growth to Filing Cabinet, then
read-only checks against the local TheBrain API on this laptop.
**Status:** Verified for 3 pairs, Growth to Filing Cabinet only. Forget
and delete not yet tested.

- **How a "move" works (Keith).** TheBrain has no move between brains.
  The user copies the Thought, pastes it in the target brain, then
  forgets or deletes the original by hand.
- **The copy gets a new id and a new brain id.** Name, kind and access
  type carry over. The creation time is the paste time, so it cannot be
  used to match a copy to its source. Nothing in the copy points back at
  the original.
- **The copy's id is computed from the source's id.** It is the UUIDv5
  of the source Thought id (as text), with the target brain's id as the
  namespace. This reproduced all three copy ids exactly. The originals
  are random (version 4) ids; the copies are version 5. Found by trying
  a short list of obvious namespace and name combinations.
- **What that gives CRO.** For a Thought that is missing or forgotten in
  one brain, compute the id it would have in every other included brain
  and look it up: a hit is an exact `moved`, with the new brain id and
  thought id. Copies that were not followed by forgetting the original
  (the same Thought alive in two brains) are found the same way
  (Feature 03). It runs forward from a source id; from a copy, CRO
  computes the copy id of every Thought it already knows and matches.
- **The Note comes with the copy.** The Markdown and the Note's
  modification time were identical in both copies of the one Thought
  that had a Note ("Move Test 3"). Compare the `markdown` field only:
  the response also holds the brain's own ids. The Note is read with
  `GET /api/notes/{brainId}/{thoughtId}`; the `/markdown` path returns
  TheBrain's HTML viewer page instead.
- **Placement.** The copy lands under the target brain's home Thought.
  The original keeps its parent.
- **Forgotten (tested 2026-11-09, "Move Test 2").** Read by id still
  works (200) and `forgottenDateTime` holds a timestamp. Name lookup
  (`nameExact`) returns 404. The Thought is not listed under its former
  parent, in siblings, or in search. Its own `/graph` returns 200 with
  no parents, children or links. Its copy in the other brain was
  unaffected. A normal graph walk never reaches a forgotten Thought; it
  can only be found by id.
- **Deleted (tested 2026-11-09, "Move Test").** Read by id returns 404,
  name lookup 404, and its `/graph` 403 with a generic message (treat
  any non-200 as gone). A Note read still returns 200 with empty text,
  so a Note read cannot prove a Thought exists. Its copy was intact and
  its computed copy id matched.
- **Detection rule (verified):** for a Thought the crawl did not reach,
  read it by id. 200 with `forgottenDateTime` set is forgotten; 404 is
  gone. In both cases compute the would-be copy id in every other
  included brain; if that Thought exists, the flag is `moved`.
- **Not tested:** other brain pairs and the other direction; pasting the
  same Thought twice into one brain (likely the same id); a copy of a
  copy; file attachments (the one attachment seen looks like the Note
  itself); deleting a whole brain; remembering a forgotten Thought (do
  its links come back?); whether a forgotten Thought's Note is readable
  (the test Thought had no Note).
- **Flags this supports** (`node_flags`): `moved` (exact, via the id
  formula), `forgotten` (still exists, hidden), `deleted` (gone, no
  copy). Title and Note matching is only a fallback for copies made some
  other way.

**When this becomes real work:** Epic 1 Feature 02, the story for a gone,
forgotten or moved Thought; Feature 03 for copies left in both brains.

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
