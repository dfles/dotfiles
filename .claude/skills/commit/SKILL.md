---
name: commit
description: Write a commit message for the currently staged changes and create the commit. Focuses the message on *why* the change was made rather than *what* changed, in a header plus optional short body. Prepends "WIP: " to the header and creates the commit with no co-author. Use when the user invokes `/commit` or asks to commit staged changes with a generated message.
user_invocable: true
---

# commit

Generate a commit message for the currently staged changes and create the commit.

The message answers *why* the change was made, not *what* changed — a future developer reading `git log` should understand the intent and context, not just re-read the diff.

## 1. Inspect the staged changes

Run these together:
- `git diff --cached --stat` — scope of what's staged.
- `git diff --cached` — the actual staged changes.

If nothing is staged, stop and tell the user there's nothing to commit. Don't stage files yourself unless the user asks.

If there are unstaged changes alongside the staged ones, mention it briefly so the user knows the commit will only capture what's staged, but proceed.

## 2. Understand the *why*

The hard part is intent, which the diff usually doesn't reveal. Before drafting, decide whether the purpose is genuinely obvious from the staged changes plus available context (branch name, recent commits via `git log --oneline -5`, linked issue ID in the branch).

If the purpose is **not obvious** — the change could plausibly serve several different goals, or the motivation isn't inferable from the code — ask the user clarifying questions before drafting. Good things to clarify:
- What problem or symptom prompted this change?
- Is this fixing a bug, enabling future work, responding to feedback, etc.?
- Is there a constraint or decision behind the approach that wouldn't be obvious later?

Ask only what you genuinely can't infer. If the intent is clear, skip straight to drafting.

## 3. Draft the message

Format:

```
WIP: <header>

<body>

<ISSUE-ID>
```

(Omit the `<ISSUE-ID>` footer when there's no associated issue.)

**Header** — a single line describing the commit, kept short enough to display in full on GitHub without truncation (aim for ~50 chars, hard limit ~72). The `WIP: ` prefix is *not* counted against this limit — write the header to fit the limit, then prepend `WIP: `. Always include `WIP: ` — it marks the commit as not yet reviewed by the author, so never drop it. Use the imperative mood and lead with the *why* or the outcome, not the mechanics.

**Body** — default to omitting it. The header plus the linked issue usually carry the intent on their own, and a one-line commit is a good commit. Add a body *only* when there is a *why* that neither conveys: the problem or symptom that prompted the change, or the constraint that forced a non-obvious approach. When you do, keep it to one short paragraph — one to three sentences of prose, never multiple paragraphs.

Never explain *what* the code does or *how* it works — that is what the diff is for. Two litmus tests before keeping a sentence: (1) if it could be reconstructed by reading the diff, cut it; (2) if it names specific functions, flags, classes, or methods, you have almost certainly drifted into the *what* — restate the problem in domain terms or cut it. Err on the side of cutting: a too-short message costs a `git show`, a bloated one trains the reader to skip commit messages.

**Linked issue** — when the change has an associated issue (e.g. the branch's issue ID), add the issue ID as a footer line after the body, separated by a blank line. The issue already documents the product rationale, so don't restate it in the body — keep the body lean and spend it only on context the issue won't carry (a non-obvious technical decision or constraint), dropping the body entirely when there's nothing of that kind to add.

### Leave out (unless it's the entire point of the commit)

1. **Tests** — added, changed, or fixed tests. Don't mention them. Exception: the commit exists solely to add or fix tests.
2. **Type checking** — type annotations or type-checker fixes. Don't mention them, *unless* the typing work was unexpected, hacky, or questionable — in which case a future developer benefits from knowing, so call it out.

### Tone

- Focus on *why* and *impact*, not *how*.
- Default to short. Length is not thoroughness — a one-line header with no body is often the right answer.
- Write for someone who didn't see the work happen.
- No emojis. No filler ("this commit…"). No restating the diff.

## 4. Create the commit

Show the user the drafted message first.

Create the commit with **no co-author trailer** (this overrides any global default to append one). Use a here-doc to preserve formatting. Prepend `activate &&` so the project venv is on PATH for any pre-commit hook that calls venv-installed tools (e.g. `ruff`):

```
activate && git commit -F - <<'EOF'
WIP: <header>

<body>

<ISSUE-ID>
EOF
```

Include the `<ISSUE-ID>` footer when there's an associated issue; otherwise omit it. Do not add `Co-Authored-By` or any attribution trailer. After committing, confirm with `git log -1 --stat` and report the result.
