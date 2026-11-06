# Notes and Findings

Keith's own findings, kept so they are not lost. These are NOT part of
any plan yet. Nothing here is decided. When a finding becomes real work,
move it into a Feature or User Story and leave a link here.

Format: newest first. Each entry has a date, a source, and a status
(Unverified / Verified / Planned).

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
