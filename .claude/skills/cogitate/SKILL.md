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

Write to `RITE_OF_IMPLEMENTATION.md` in the current directory. If the file already exists, do **not** overwrite it — surface that to the user and stop.

Keep the plan high-level and concise. The engineer reads it to judge the approach and the commit sequence, not to learn the codebase; implementation detail (exact params, prop names, line numbers) belongs in the code, not the plan. The plan must contain these sections, in order:

1. **Overview** — What needs to be done and why (2–3 sentences).
2. **Blockers** — Anything that must be resolved before work can start (an unmerged prerequisite, a decision that changes the whole approach). Omit the section when there are none.
3. **Implementation Steps** — See below.
4. **Open Questions / Risks** — Anything needing clarification that does not block starting.
5. **Appendix: Codebase Areas** — Reference list of relevant files and modules, one short line each. This is the only place file paths are listed in bulk.

### Implementation Steps

- Each step is one unit of value and roughly maps to one commit. Order building blocks first (shared models, endpoints, components), then the steps that compose them into user-facing features.
- Do **not** split steps by layer (backend / frontend / tests). A step carries everything its value needs: the backend change, the frontend change, and its tests together.
- Format each step as `### N. <short headline>` followed by a sentence or two of body saying what changes and why. Use a short sub-list only when a step genuinely has distinct parts.
- Fold testing into the step it covers (one clause naming what the tests pin). Add a short **Manual QA** list after the steps only for end-to-end checks that span several steps.

### Numbering

Number every entry under **Blockers**, **Implementation Steps**, and **Open Questions / Risks** (`### 1.`, `### 2.`, …), even when there is only one. The engineer discusses these by number, so they must be individually addressable. Keep each open question to a few sentences with a recommendation.

Write only the plan. The engineer will review it before implementation starts.
