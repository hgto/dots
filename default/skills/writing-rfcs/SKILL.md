---
name: writing-rfcs
description: Use when drafting, writing, or creating an Engineering RFC at Traversal — a design doc, proposal, exploration, migration, or integration RFC, or a new page in the Engineering RFCs database.
---

# Writing Traversal Engineering RFCs

Draft a strong Engineering RFC and create it as a new page in Traversal's Engineering
RFCs database. The writing guidance below is baked in; the template structure is
fetched live so you always use the latest version.

## Workflow

### 1. Gather context (hybrid)

Take whatever the user already has — a brief, PR links, design docs, Slack threads, an
incident, or just the problem in their own words. Read the linked material. Do **not**
block on a perfect brief; you will interview for gaps in step 4.

### 2. Fetch the live template

Call `notion-fetch` on page `36d2fa20e386804b806debfe4f7098e4` (RFC: New Engineering
RFC template). Its headings are the **authoritative skeleton** for the document —
currently:

- 📍 Executive summary
- 🏗️ Architecture
- 📝 Engineering considerations → ↫ Alternatives considered · 🔍 Observability and
  monitoring · 🛡️ Security · 💰 Costs
- 🔗 References

If the fetched template differs from this list, follow the fetched version. Never add
new top-level headings — fold everything below into these sections.

### 3. Draft into the skeleton

Fill each template section using the guidance in **Writing guidance** below. Map the
richer guidance onto the template's headings:

| Guidance content | Goes under |
|---|---|
| Problem statement, why-now, what we propose, decision asked, goals/non-goals | Executive summary |
| Requirements (functional + non-functional), current vs. proposed design, data model, control flow, failure modes, rollout & rollback, open questions | Architecture |
| Alternatives table + recommendation | Alternatives considered |
| Dashboards, alerts, runbooks, ownership, on-call impact | Observability and monitoring |
| Permissions, data access, secrets, abuse cases | Security |
| Infra/storage/compute cost, steady-state cost, guardrails | Costs |
| Links to related RFCs, PRs, dashboards, incidents | References |

### 4. Interview only for the gaps

Ask focused questions for anything the context did not cover — one topic at a time.
Prioritize: the decision being asked, the alternatives, rollout/rollback, and the
security/cost/ops sections (these are most often thin).

### 5. Self-review against the checklist

Run the **Pre-share checklist** below. Fix gaps before creating the page.

### 6. Create the Notion page

Resolve the author: call `notion-fetch` with id `self` to get the current user id.
Show the drafted title and `RFC Type`. If the user already authorized creating the RFC, proceed; otherwise confirm before writing.
Create the page with `notion-create-pages` into the Engineering RFCs data source:

- Parent / data source: `collection://3252fa20-e386-8028-a092-000bdf7ccc55`
- `Title`: the RFC title, prefixed `RFC: `
- `Author`: the current user (from `self`)
- `RFC Type`: default `Design`; infer from context (One-Pager / Design / Exploration /
  Migration / Integration); if unsure, ask the user to pick.
- `Status`: `Draft`
- Leave `Reviewers` and `Teams` unset. (Reviewer *asks* still go in the body per
  guidance principle 12 — that is separate from the `Reviewers` property.)
- Do not set `Created At` or `Last Updated`; Notion manages those automatically.
- Body: the drafted content under the fetched template headings.

Return the new page URL. If a write fails on a property, trust the live data-source
schema (`notion-fetch` the `collection://…` id) over these baked values.

## Writing guidance (the 12 principles, condensed)

1. **Sharp executive summary.** Readable in 60–90s. Answer: what problem, why now,
   what we propose, what decision/feedback is needed. Shape: *"We currently [gap]. This
   causes [impact]. I propose [solution], which will [outcome]. This RFC asks reviewers
   to align on [decision] by [date]."*
2. **Concrete problem statement.** Start with the failure mode, not architecture. Give
   a real scenario, who's affected, the cost of doing nothing, why the current approach
   is insufficient, and what's explicitly out of scope.
3. **Separate requirements from implementation.** List functional requirements (what
   the system must do, inputs/outputs, workflows) and non-functional requirements
   (reliability, security, latency, cost, observability, ops burden, backward
   compat, migration safety) so reviewers can debate them independently.
4. **Use personas/use cases** when product- or ops-facing (on-call, FDE, team lead,
   security reviewer, customer). For each: what they do today, what breaks, what the
   change enables.
5. **Be explicit about alternatives** with a table and a per-row recommendation:

   | Option | Description | Pros | Cons | Recommendation |
   |---|---|---|---|---|

6. **Make the recommendation unmistakable.** State which option and why it best meets
   the requirements, name the main downside, and how it's mitigated. No vague endings.
7. **Architecture, navigable.** Use subsections: current architecture, proposed
   architecture, data model/interfaces, control flow, failure modes, rollout, rollback,
   observability, security, cost, open questions. Lead complex parts with a small
   diagram or bullet sequence.
8. **Security, cost, ops are first-class.** Security: new permissions, data access,
   customer-data exposure, authn/authz, secrets, abuse cases. Cost: new infra, added
   storage/compute/logs/API calls, steady-state cost, guardrails. Ops: dashboards,
   alerts, runbooks, ownership, on-call impact, backfill/migration, failure/rollback.
9. **Make rollout and reversibility obvious.** Phases, feature flags/gates, migration
   order, validation checks, rollback procedure, definition of done, per-phase owner.
   Answer: *if this goes badly, how will we know and how do we get back to safety?*
10. **Open questions as a table**, not buried prose:

    | Question | Why it matters | Owner / reviewers | Proposed default |
    |---|---|---|---|

11. **Keep the writing crisp.** Short sections with descriptive headings; bullets and
    tables over dense prose; conclusion before details; define acronyms on first use;
    link related RFCs/PRs/dashboards/incidents; delete anything that doesn't help the
    decision.
12. **Make reviewer asks explicit.** End (in the executive summary or references) with
    who should review, what feedback you want, the comment deadline, what approval
    means, and what happens after approval.

## Pre-share checklist

- [ ] A reviewer can understand the proposal from the executive summary alone.
- [ ] Problem statement is concrete and tied to real impact.
- [ ] Requirements are separated from implementation.
- [ ] Alternatives are fairly represented with a clear recommendation.
- [ ] Security, cost, and operations are all covered.
- [ ] Rollout is phased and reversible.
- [ ] Open questions are explicit.
- [ ] Reviewer asks and deadlines are clear.
- [ ] The doc is crisp enough to review asynchronously.
