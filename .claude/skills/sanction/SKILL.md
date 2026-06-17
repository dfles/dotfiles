---
name: sanction
description: Conduct a structured pull-request review and produce a numbered, severity-banded review file plus a terse chat index. Use when the user invokes `/sanction <PR#>` or asks to review a GitHub PR using the sanction methodology. Fetches PR details, Linear context, and pending review drafts via `gh` and the Linear API; writes the detailed review to `.sanction-review.md` and reports only an index in chat.
user_invocable: true
---

# sanction

Review a GitHub pull request and produce structured, actionable feedback. Invoked as `/sanction [PR-NUMBER] [--depth=N]`.

## Resolving the PR

Resolve which PR to review in this order:

1. **Pre-fetched context** — if the system prompt already identifies a PR (the `sanction` bin wrapper provides PR number, branch, URL, commits, plus discussion / Linear / pending-draft blocks), use that and **skip section 1 entirely**. Do not re-fetch.
2. **Explicit arg** — if the user passed a PR number, use it.
3. **Current branch** — `gh pr view --json number,headRefName,baseRefName,...` with no number argument inspects the PR for the current branch. Use this when invoked from a worktree without an explicit PR.

If none of these resolve, ask the user for a PR number before continuing.

## 1. Gather context

Fetch the PR body, conversation, reviews, and inline comments. The `gh` CLI infers the repo from the current working directory.

```bash
gh pr view <PR> --json headRefName,baseRefName,title,body,url,commits,comments,reviews
gh api "repos/{owner}/{repo}/pulls/<PR>/comments" --paginate \
  --jq '.[] | "[\(.user.login) on \(.path):\(.line // .original_line // "general")]:\n\(.body)"'
```

Then look for **pending review drafts owned by the current user**. These are unsubmitted drafts and live under the review itself, not in the public comments endpoint:

```bash
GH_USER=$(gh api user --jq .login)
gh api "repos/{owner}/{repo}/pulls/<PR>/reviews" --paginate \
  --jq ".[] | select(.state == \"PENDING\" and .user.login == \"$GH_USER\") | .id" \
  | while read -r RID; do
      gh api "repos/{owner}/{repo}/pulls/<PR>/reviews/$RID/comments" --paginate \
        --jq '.[] | "[draft on \(.path):\(.line // .original_line // "general")]:\n\(.body)"'
    done
```

If `LINEAR_API_KEY` is set, extract Linear issue IDs from the PR body and branch name (pattern `[A-Z]+-[0-9]+`) and fetch each:

```bash
curl -s -X POST -H "Authorization: $LINEAR_API_KEY" -H "Content-Type: application/json" \
  --data '{"query":"query($id:String!){issue(id:$id){identifier title description parent{identifier title description} project{name description}}}","variables":{"id":"<ISSUE-ID>"}}' \
  https://api.linear.app/graphql
```

## 2. Read the changeset

```bash
git diff origin/<base>...HEAD       # full changeset, default
git diff HEAD~<DEPTH>...HEAD        # if --depth=N was passed
```

Read changed files in full where useful — diffs hide context.

## 3. Examine

Do not run tests, linters, type checkers, or formatters. CI already reports those on the PR. Focus on what a human reviewer adds beyond CI.

Look for:

- **Bugs** — Logic errors, edge cases, missing null/error handling, race conditions, off-by-one errors.
- **Ripple effects** — What does this change affect beyond the obvious? Database migrations, caching, permissions, background tasks, serialization, frontend contracts.
- **Encapsulation** — Is the implementation in the right package/layer/module/class? Does it expose unnecessary complexity to callers, or force them to understand internals they shouldn't?
- **Interfaces** — API contracts, function signatures, data model changes. Clean, consistent, backward-compatible?
- **Alternatives** — Is there a simpler approach the author may not have considered? Existing patterns in the codebase that fit better?
- **Best practices** — Reference project style guides and existing patterns. Call out deviations.

Before reporting a finding, check whether the author has already acknowledged or tracked it — in the PR description, the PR conversation, an inline reply, or the linked Linear issue (including its parent/project description). A known limitation, deferred follow-up, or deploy step the author already flagged is not a fresh discovery. Still report it, but mark it as acknowledged so the reviewer knows it's already on the author's radar rather than missed (see the acknowledgment rule under output).

## 4. Validate any pending review drafts

If the current user has unsubmitted draft comments on this PR, examine each one against the actual code **before** producing your own findings. For each draft, check:

- Is the claim correct? Could it be tightened, broadened, or rephrased to be clearer?
- Is the suggested fix the right one, or is there a better approach?
- Have I missed a related issue nearby that the same comment should cover?

The output goes in a dedicated section at the top of the review file (see below). If a draft is wrong, say so plainly.

## 5. Output — two artifacts

### Artifact 1: `.sanction-review.md`

Write the detailed review to `.sanction-review.md` in the current directory using the Write tool. This is the canonical document the reviewer reads in their editor.

Structure:

- If pending review drafts were provided, start the file with a `## Pending review draft feedback` section. Reference each draft by file:line, same item shape as below. Number these items `D1`, `D2`, `D3`, … (D-prefixed, separate from the findings sequence). If a draft is wrong, say so plainly.
- Then severity bands as headings: `## High`, `## Medium`, `## Low`. Omit empty bands.
- Within each band, group items by file path.
- Number findings continuously across the severity bands starting at 1 (1, 2, 3, …) so items can be referenced by number. The draft section uses its own `D`-prefixed sequence; cross-references between the two use the appropriate prefix (e.g. "See item 2", "See D3").

Each item uses exactly this shape — no extra prose, no preamble, no positive commentary:

```
### N. file/path.ext:LINE — [severity] one-line summary

**Why:** 1–2 sentences on the actual problem.
**Fix:** the concrete change to make, or "n/a" if reporting only.
```

Rules:

- Summary line ≤15 words.
- Banned hedging — do not write "consider", "perhaps", "might want to", "could potentially", "it would be worth", "you may want to", "I'd suggest", "if you have time". State the issue and the fix directly.
- No "what was done well" section. Only feedback the author should act on.
- Line references use `file.ext:LINE` or a range like `file.ext:120-145`.
- Acknowledged items — when the author already tracks a finding in the PR or linked Linear issue, append `, acknowledged` to the severity tag (e.g. `[medium, acknowledged]`), name where it's tracked in the **Why** (e.g. "Author acknowledged this in the PR description"), and set **Fix:** to `n/a — tracked by author. Reporting only.`. Mirror the tag in the chat index summary.

### Artifact 2: chat index

Your final message in this chat session contains only:

- One line confirming `.sanction-review.md` was written.
- The terse index, one line per item, in the same order as the file (drafts first, using their `D`-prefixed labels): `N. file:line [severity] summary`
- A final line: "Ask to expand any item by number for more detail or alternatives."

Do not paste full findings into chat — the reviewer reads the markdown file in their editor.

## 6. Expansion follow-ups

When the reviewer asks to expand an item by number, give a focused follow-up: deeper explanation of why, alternative approaches, or related code affected by the same fix. Do not re-paste the index.
