---
name: cogitate
description: Generate an implementation plan for a Linear issue, written to RITE_OF_IMPLEMENTATION.md in the current directory. Use when the user invokes `/cogitate <ISSUE-ID>` or asks for an implementation plan for a specific Linear ticket. Fetches the issue via the Linear API, explores the codebase for relevant patterns, and produces a structured plan the engineer reviews before implementation.
user_invocable: true
---

# cogitate

Produce an implementation plan for a Linear issue. Invoked as `/cogitate <ISSUE-ID>`.

If the user did not provide an issue ID, ask for one before continuing.

## 1. Fetch the issue

`LINEAR_API_KEY` must be set in the environment. Query the Linear GraphQL API:

```bash
curl -s -X POST -H "Authorization: $LINEAR_API_KEY" -H "Content-Type: application/json" \
  --data '{"query":"query($id:String!){issue(id:$id){identifier title description branchName parent{identifier title description} project{name description}}}","variables":{"id":"<ISSUE-ID>"}}' \
  https://api.linear.app/graphql
```

Capture title, description, branch name, parent issue, and project context. If the response contains an `errors` array or no issue, stop and tell the user.

## 2. Explore the codebase

Find the files, modules, apps, or components relevant to the issue. Read the existing patterns — propose an approach that fits the codebase's conventions rather than fighting them.

## 3. Write the plan

Write to `RITE_OF_IMPLEMENTATION.md` in the current directory. If the file already exists, do **not** overwrite it — surface that to the user and stop. The plan must contain these sections, in order:

1. **Overview** — What needs to be done and why (2–4 sentences).
2. **Codebase Areas** — Relevant files, modules, apps, or components.
3. **Implementation Steps** — Ordered, specific steps with enough detail to act on.
4. **Testing Approach** — How to verify the implementation is correct.
5. **Open Questions / Risks** — Anything needing clarification before work begins.

Write only the plan. The engineer will review it before implementation starts.
