---
name: commit
description: Write a commit message for the currently staged changes and create the commit. Focuses the message on *why* the change was made rather than *what* changed, in a header + body format. Prepends "WIP: " to the header and creates the commit with no co-author. Use when the user invokes `/commit` or asks to commit staged changes with a generated message.
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
```

**Header** — a single line describing the commit, kept short enough to display in full on GitHub without truncation (aim for ~50 chars, hard limit ~72). The `WIP: ` prefix is *not* counted against this limit — write the header to fit the limit, then prepend `WIP: `. Use the imperative mood and lead with the *why* or the outcome, not the mechanics.

**Body** — succinct prose explaining *why* the change was made: the problem it addresses, the context a future developer would need, and any non-obvious decision behind the approach. Wrap as normal prose; don't narrate the diff line by line. Omit the body only if the header fully captures the intent and there's genuinely nothing to add.

### Leave out (unless it's the entire point of the commit)

1. **Tests** — added, changed, or fixed tests. Don't mention them. Exception: the commit exists solely to add or fix tests.
2. **Type checking** — type annotations or type-checker fixes. Don't mention them, *unless* the typing work was unexpected, hacky, or questionable — in which case a future developer benefits from knowing, so call it out.

### Tone

- Focus on *why* and *impact*, not *how*.
- Write for someone who didn't see the work happen.
- No emojis. No filler ("this commit…"). No restating the diff.

## 4. Create the commit

Show the user the drafted message first.

Create the commit with **no co-author trailer** (this overrides any global default to append one). Use a here-doc to preserve formatting:

```
git commit -F - <<'EOF'
WIP: <header>

<body>
EOF
```

Do not add `Co-Authored-By` or any other trailer. After committing, confirm with `git log -1 --stat` and report the result.
