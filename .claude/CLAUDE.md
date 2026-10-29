# Responses

- Keep responses concise. Lead with the answer or the decision; leave out reasoning I did not ask for. I will ask for detail when I want it.
- Number any list of steps, options, findings, or open questions so we can refer to items by number in follow-up.

# Writing styles

## Steps and procedures

- Write steps and procedures in Simplified Technical English (STE): one action per step, verb first, imperative and active voice, sentences of 20 words or fewer, one meaning per word, no idioms.

## Overviews and explanations

- Do not write flat. Split the content into segments that each answer one question, with a heading or label per segment.
- Tell the reader a story: where things stand, what the problem is, what changes, and what it means for the reader. Ground abstract points in a concrete example from the work.
- Write a doc's summary as a "tl;dr" heading followed by a short bulleted list, not a prose paragraph.

## Clarity

- When more than one noun could be the antecedent of a pronoun ("it", "this", "that", "they"), repeat the noun instead of using the pronoun.

## State, not history

- In code, comments, docstrings, and docs, describe only the current state and the active intent. Leave out how the decision was reached, rejected alternatives, and change language ("now", "previously", "instead of the old"). Decision history belongs in commit messages.

## "uwotm8"

- If I say "uwotm8", I could not parse your last message. Rewrite it: use simpler words, ground the context (what we are looking at and why it matters), and tell it as a story. Do not just shorten or repeat it.

## Social rules

These team norms apply to anything drafted for another person: PR descriptions, Linear issues, Slack messages, docs, review comments.

1. Review before you inflict. Nothing reaches another person unreviewed: re-read every draft as its recipient before presenting it, and never send it on without my review.
2. Anyone who receives a huge doc can ask for a meeting to be taken through it. This is the backstop for rule 1, so keep docs for others as short as the content allows and lead with a tl;dr that stands alone.
3. AI-generated content can be rejected without effort, including tickets and PRs with unreadable descriptions. Rejection is a hard decline: when I reject a draft, rewrite it rather than patching it.

# When planning

- When coming up with plans check if we should write it to a markdown file in the local directory

# Shell commands

- Before running any verbose shell invocation — anything involving `.venv`, `env $(cat .env | xargs)`, or a multi-step `source … && …` chain — check for a project alias. Run `alias <name>` or `type <name>` if unsure. Project `CLAUDE.md` / `CLAUDE.local.md` files also typically list the aliases they expect to be used.
- Zsh functions/aliases defined in `~/.zshenv` (and files it sources) ARE available to the Bash tool. Do not fall back to the long form on the assumption that they won't expand.

# Working with git

- Prefer rebasing when fixing issues related to previous commits within the same working branch
- Keep commit messages high level and focused on why the change was made. Commit messages are the home for decision history that code and docs leave out
- Never add an AI `Co-Authored-By` trailer. A human is on the line when things go wrong, so attribution stays human.
- Add a human `Co-Authored-By` trailer only when a commit would not exist, or would look materially different, without a reviewer's idea (e.g. a reviewer proposed the shape and the commit exists to adopt it). Nits, one-line corrections, approvals, and fixups that get squashed into a commit the reviewer did not shape get no trailer.

# Markdown

- Never hard-wrap markdown files. Write each paragraph as a single line and let the renderer handle wrapping.

# File paths

- Always write file paths relative to the project's working directory root, in chat and in any file. `backend/app/api/views.py:179`, never `app/api/views.py:179`. This keeps them jumpable (`gF`) and clickable.
- The reference point is the project root, not the shell's current directory. A `cd` earlier in the session does not change how paths are written — if tool output is relative to a subdirectory, re-prefix it before quoting it back.

# Code Comments

- Only write comments to describe the why of the code rather than what the code is doing (see "State, not history" under Writing styles)
- Err on the side of not writing comments if the code is self-explanatory
- Keep comments concise: a comment should only explain the novel or unexpected part, never restate what the code plainly does; the goal is to help a developer understand
- Comment a field (model, serializer, class attribute) only when its name isn't self-descriptive
- Keep comments terse and scope the intent to the implementation: an internal helper's comment can speak to its immediate surroundings, but a broadly-reusable method (e.g. a queryset method) must not be described as bound to a single caller, use case, or change
- Use a single backtick for inline code references (functions, classes, args) in comments and docstrings; never double backticks

# Git Commit Best Practices

- Before making commits be sure to fix any lint/formatting issues. The project itself should have rules for linting/formatting

# Python Development

- Use "activate" to activate the python virtual env for a project
- When writing docstrings and documentation prefer neutral language (no you/I/we)

# Testing

## Where tests live

- Test through the layers. Put edge cases and the full range of behaviors at the unit(ish) level (model methods, services, pure functions), where setup is cheap and failures point at one decision.
- Keep API/integration tests focused on wiring and contracts: that each endpoint reaches the right logic, returns the right status and shape, and persists the right side effects. These catch underlying changes, not every branch.
- Test each decision once, at the level where it is made. If a method delegates a check to a collaborator (e.g. a permission helper, a roster lookup), do not re-test the collaborator's branches through the caller; one test that the caller honors the collaborator's answer is enough.
- Avoid full overlap between tests. Before adding a test, check whether an existing test at another layer already fails for the same regression; if so, skip it or make it cover something the other does not.
- Name test files after the source module they cover (`test_views.py` for `views.py`). When code moves between modules, move its tests with it.

## Writing them

- Write tests to be read. A test should show a future developer what the behavior is and why it matters, not just pin current output.
- Name tests after the behavior in domain terms (`test_guest_cannot_invite_guests`, `test_one_invalid_row_rolls_back_the_import`), not after the method or the mechanics (`test_assignment_kind_returns_none_2`).
- Keep setup to what the test needs. Drop fixtures, arguments, and helper parameters no remaining test uses. Prefer shared class-level setup (e.g. `setUpTestData`) when tests do not mutate it.
- Comment a fixture or assertion only when the reason is not obvious: why a fixture exists, why a status is 403 rather than 400, what a subtle guard protects.
- Prefer factories over direct model construction.
- Assert strictly: the exact set of rows or values (`assertCountEqual` with expected tuples), not a count or a membership loop. Use identity assertions for booleans and enums (`assertIs(value, True)`), not truthiness.
- Mock only at boundaries or to isolate the unit under test (e.g. mocking a classifier to test a service's handling of each result). Do not mock the thing being tested, and prefer real fixtures when the test is about how pieces fit together.

## Keeping them honest

- Every test should fail for a plausible regression. When adding a guard or a side effect, temporarily break it (remove the check, skip the write) and confirm a test fails; if none does, the coverage is missing or aimed at the wrong layer. Restore from a saved copy, never with a checkout that could drop uncommitted work.
- Be judicious. A smaller suite where each test earns its place beats exhaustive coverage that duplicates itself; when a review pass finds tests that only restate other tests, cut them.
- When refactoring moves logic, move or rewrite its tests to target the new home rather than leaving tests pointed at a removed function or re-asserting the old shape.
- Report test results faithfully: if a failure looks unrelated, confirm it (rerun alone, or on the base commit) before calling it pre-existing or flaky.

