---
name: expurgate
description: Give the unstaged changes a cleanup pass that simplifies docstrings, cuts comments down to what the code and commit history cannot say, and removes tests that overlap, re-verify imported or framework behavior, or cover impractical state. Edits the working tree directly; never stages or commits. Use when the user invokes `/expurgate` or asks for a cleanup pass on docstrings, comments, or tests in their uncommitted work.
user_invocable: true
---

# expurgate

Strip the unstaged changes of everything the next developer does not need. The code should carry the *what*, the commit history should carry the decision history, and docstrings, comments, and tests should carry only what neither of those can.

The global writing rules in `~/.claude/CLAUDE.md` (Code Comments, Testing, "State, not history") apply throughout. This skill is the pass that enforces them on work already written.

## 1. Gather the scope

Run these together:
- `git diff --stat` and `git diff`: the unstaged changes to tracked files.
- `git status --porcelain`: untracked files (`??`) are also in scope.

If there are no unstaged or untracked changes, stop and say so.

Only touch lines the diff added or changed. Pre-existing code outside the diff is out of scope, even if it breaks the same rules. Mention it at the end if it is egregious, but do not edit it.

## 2. Docstrings

Every docstring must give the next developer what they need to use the thing correctly, and nothing else.

1. Cut prose that restates the signature, the name, or the body.
2. Prefer a short usage example over a paragraph of explanation when the call shape is not obvious.
3. Keep caveats and gotchas apart from the general description, under their own short paragraph or label, so a reader skimming for usage does not have to dig them out.
4. Remove docstrings that add nothing over a self-descriptive name and signature.

## 3. Comments

A comment survives only when it explains something the code (the *what*) and the commit history (the decision history) cannot. In practice that is usually:
- a warning: what breaks if someone changes this, or
- the reason for a specific implementation, including why the obvious alternative does not work.

Remove comments that narrate the code, restate a name, or describe how the code got to this state ("now", "previously", "instead of the old"). Shorten survivors to the novel part only.

## 4. Tests

Coverage should be good, not exhaustive. Read each new or changed test against the code under test and the rest of the suite.

1. **Overlap:** remove or merge a test when another test, at the same or another layer, already fails for the same regression. Test each decision once, at the level where it is made.
2. **Imported behavior:** remove tests and assertions that re-verify behavior the code imports rather than owns, especially framework behavior (ORM lookups, serializer field validation, model field defaults, cascades). Keep the setup data that behavior needs for the code under test, but assert only on the decisions the code under test makes.
3. **Extreme edge cases:** remove tests for inputs the code will not plausibly see.
4. **Impractical state:** a test may cover state the data model *allows* but that never happens in practice, such as a nullable field that is always set. The data model can be outdated, so do not decide this alone. Collect these tests, and before removing any of them ask the user a numbered list of questions naming the field or state and why it looks impractical. Remove only what the user confirms.

Apply the overlap, imported-behavior, and edge-case removals first, then ask the impractical-state questions in the same turn.

After changing tests, run the affected test modules with the project's test command. Report failures faithfully.

## 5. Report

Never stage or commit. End with a short numbered list grouped by Docstrings, Comments, and Tests, one line per change naming the `file:line` and what was cut or rewritten. Follow it with any open impractical-state questions and any out-of-scope issues worth flagging.
