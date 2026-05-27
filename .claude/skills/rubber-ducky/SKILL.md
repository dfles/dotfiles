---
name: rubber-ducky
description: Build context around a Linear issue so the user can start talking and thinking through the problem. Use when the user invokes `/rubber-ducky <ISSUE-ID-or-link>` or asks to get up to speed on / warm up context for a specific Linear ticket. Fetches the issue (and its comments, parent, project) from Linear, reads the relevant parts of the codebase, then reports a short summary of the understood problem for verification and asks clarifying questions. Does NOT plan or start implementation.
user_invocable: true
---

# rubber-ducky

Warm up context around a Linear issue so the user can start thinking out loud about it. Invoked as `/rubber-ducky <ISSUE-ID-or-link>`.

The user is using this to load shared context — you are a rubber ducky who has read the ticket, and sometimes the implementer later. The goal is a shared, verified understanding of the problem. **Do not write an implementation plan, propose a solution, or start work.** Stop after the summary and questions.

## 1. Resolve the issue identifier

Accept either form:

- A bare identifier like `ABC-123`.
- A Linear URL like `https://linear.app/<workspace>/issue/ABC-123/<slug>` — extract the `[A-Z]+-[0-9]+` identifier from it.

If the user gave neither, ask for one before continuing.

## 2. Fetch the issue

Prefer the **Linear MCP** if its tools are available (`mcp__linear-server__*`):

- `get_issue` for the issue itself (title, description, state, assignee, labels, parent, project, sub-issues, relations).
- `list_comments` for the discussion on the issue.

If the Linear MCP is **not** available, fall back to the GraphQL API. `LINEAR_API_KEY` must be set in the environment:

```bash
curl -s -X POST -H "Authorization: $LINEAR_API_KEY" -H "Content-Type: application/json" \
  --data '{"query":"query($id:String!){issue(id:$id){identifier title description branchName state{name} assignee{name} labels{nodes{name}} parent{identifier title description} children{nodes{identifier title state{name}}} relations{nodes{type relatedIssue{identifier title}}} project{id name description} comments{nodes{body user{name}}}}}","variables":{"id":"<ISSUE-ID>"}}' \
  https://api.linear.app/graphql
```

If neither path works (no MCP and no `LINEAR_API_KEY`, or the response has an `errors` array / no issue), stop and tell the user what is missing.

Capture: title, description, current state, parent, sub-issues, related issues, project, and the comment thread. The comments often hold the real intent, scope cuts, and decisions — read them.

## 3. Read the project and any design / context docs

The issue usually belongs to a Linear **project**, and the project is where the broader goal and design thinking live. Read the project description and any documents attached to it.

Via the MCP: `get_project` for the project (description and content), and `list_documents` / `get_document` for documents under it.

Via GraphQL, fetch the project's content and its documents:

```bash
curl -s -X POST -H "Authorization: $LINEAR_API_KEY" -H "Content-Type: application/json" \
  --data '{"query":"query($id:String!){project(id:$id){name description content documents{nodes{title content url}}}}","variables":{"id":"<PROJECT-ID>"}}' \
  https://api.linear.app/graphql
```

Also follow any design-doc or spec links found in the issue or project (Linear documents, Google Docs, Figma, etc.) where you can reach them.

Treat these as **the current basis of understanding, not a contract.** Designs evolve, and the doc may lag behind or contradict the issue and its comments. Where they diverge, surface the divergence rather than silently picking one — it is often exactly what's worth talking through.

## 4. Explore the codebase for grounding

Read enough of the codebase to discuss the issue concretely — locate the files, modules, or components the issue touches and skim how they currently work. Read for understanding, not to design a change. Note anything that looks like it complicates or contradicts the issue's framing.

Identify **which architectural layer** the affected code sits in. If the repo documents its own layering (for example a backend/architecture style guide describing core vs. feature vs. aggregation layers, and the dependency rules between them), consult it and classify each affected area accordingly — the layer shapes what a change is allowed to depend on and where new code should live. If the repo has no such guide, skip this.

Also do a quick scan for **work already in flight** around the area: an existing branch matching the issue's branch name, an open PR, or recent commits touching the same files. Knowing something is already started changes the conversation.

Keep this proportional: enough to hold a real conversation, not an exhaustive audit.

## 5. Report understanding for verification

Output directly in chat (do not write a file). Keep it tight — this is a checkpoint, not a document:

- **Problem** — what the issue is asking for and why, in 2–4 sentences, in your own words. Restating it in your own words is the point; it's what lets the user catch a misread.
- **Project context** — 1–2 sentences on how this issue fits the larger project goal, plus anything notable from the design docs (and any place a doc and the issue diverge).
- **Where it lives** — the main files/modules/components involved, as a short list with `file_path` references. Note the architectural layer of each area when the repo defines layers.
- **My read** — 1–3 bullets on anything notable: assumptions you're making, scope you think is in vs. out, related/sub-issues or in-flight work, anything in the code that complicates the issue's framing.

Then **clarifying questions** — wherever there is genuine uncertainty about intent, scope, edge cases, or constraints, ask. Prefer a small number of specific, decision-shaping questions over a long list. If there is genuinely nothing unclear, say so rather than inventing questions.

End by inviting the user to correct the summary or start talking through the problem. Do not proceed to planning or implementation unless they ask.
