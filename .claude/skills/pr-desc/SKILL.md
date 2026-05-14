---
name: pr-desc
description: Write a PR description to pr-desc.md at the repo root. Summarizes the commits on the current branch in a fixed skeleton (title, intro, "What changed", "Closes X") with optional sections for behavior changes and follow-ups when the commits warrant them. Use when the user invokes `/pr-desc` (default scope: commits diverged from main) or `/pr-desc <N>` (override to the last N commits).
user_invocable: true
---

# pr-desc

Produce a PR description for the current branch and write it to `pr-desc.md` at the repo root.

Invocation:
- `/pr-desc` — summarize commits diverged from `main`.
- `/pr-desc <N>` — summarize the last N commits.

## 1. Gather commits

Default: `git log main..HEAD --reverse --format='%H%n%s%n%n%b%n---'`. Reverse so commits read in landing order. If the user passed `<N>`, use `git log -n <N> --reverse ...` instead.

If the range is empty, stop and tell the user there's nothing to summarize.

Also capture the diff stat: `git diff --stat main..HEAD` (or `HEAD~N..HEAD`). Use it to confirm scope but don't paste it into the description.

## 2. Detect the issue ID

Inspect the current branch name (`git branch --show-current`). Match the leading `<prefix>-<num>` (regex `^([a-z]+)-(\d+)`). If found, uppercase the prefix to produce `<PREFIX>-<NUM>` and use this in the title and the trailing `Closes <PREFIX>-<NUM>` footer.

If no match, leave the title's issue prefix blank and omit the `Closes` line. Tell the user the issue ID couldn't be inferred so they can edit it in.

## 3. Draft the description

The skeleton has four required parts:

1. **Title** — `## <ISSUE-ID>: <short summary>` (or just `## <short summary>` if no issue ID). The summary should answer "what's the takeaway of this PR" in under ~70 chars.
2. **Intro paragraph** — 2–4 sentences naming the *why*: the problem the PR addresses, ideally with the visible symptom. Don't narrate the implementation.
3. **`## What changed`** — bullet list of the load-bearing changes. One bullet per coherent change (typically one bullet per commit, but merge or split as needed). Lead each bullet with the *what* (bolded), then a sentence on the *why* or the shape.
4. **Closes line** — `Closes <ISSUE-ID>` at the very bottom, separated by a blank line. Omit if the issue ID couldn't be inferred.

Add these conditional sections **only when the commits actually warrant them**:

- **`## Behavior changes`** — when something externally observable shifts (API shape, semantics under a flag/config, perf characteristics that callers care about). One bullet per change; mention what's unchanged if it's load-bearing for confidence.
- **`## Follow-ups`** or **`## Affects upcoming work`** — when commits explicitly hand off to a follow-up ticket. Reference issue IDs.

Tone:
- Tight. Focus on *why* and *impact*, not *how*.
- Write for a reviewer who didn't see the conversation that produced this work.
- No emojis. No "this PR" filler. No restating the commit subject as a bullet.

## 4. Write the file

Target: `pr-desc.md` at the repo root (`git rev-parse --show-toplevel`).

If the file does not exist, write it.

If the file **already exists**, do not overwrite silently. Show the user a unified diff of the new vs. existing content (a textual `diff -u` is fine) and ask whether to overwrite, then act on their answer. Do not append; this is a single-purpose scratch file.

After writing, tell the user the file was written and remind them to review before posting to GitHub.
