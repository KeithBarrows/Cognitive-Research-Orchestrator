# User Story 06 — Embedding Model Pulled and Timed

**Status:** Done 2026-11-05

**Story:** As the CRO developer, I want `nomic-embed-text` running in
Ollama with measured speed, so I know it is fast enough on this
laptop.

**Done when:** The model is pulled, and the time to embed a short text
and a long text is recorded here.

**Notes:** Model chosen 2026-11-05: `nomic-embed-text`, 768
dimensions (recipe default; fixed at first database start). Pulled in
22 s (274 MB). Measured on the CPU, calling Ollama directly: cold
load 2.2 s; warm short text about 0.05 s; about 1000 characters about
0.38 s; about 4000 characters 1.7 to 2.1 s. Context: a 3B chat model
on the desktop produced about 4 words per minute; chat models write
one word at a time, an embedding model does one pass per text, and
this one is fast enough. The model survived restarts. The first call
after a restart is slower (about 2.5 to 3.7 s, likely the model
reloading). Ollama in Docker Desktop runs on the CPU. If a GPU is
ever enabled it must be pinned to the base's GTX 1660 Ti, never the
tablet half.
