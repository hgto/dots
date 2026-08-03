---
name: build-program-cockpit
description: Use when asked to create, reconstruct, audit, or maintain a project cockpit, migration cockpit, central context store, PR train tracker, multi-repository rollout ledger, or agent handoff system. Builds a documentation-first control plane with source precedence, exact-head review, human-in-the-loop merges, rollout contracts, incident guardrails, local-development compatibility, and bounded context packets.
---

# Build a Program Cockpit

Build a documentation-first control plane for a long-running, high-risk, or multi-repository program. The cockpit centralizes durable context and points to live operational truth. It does not become a source-code integration branch, deployment controller, or substitute for the systems it tracks.

This skill is public and generic. Never copy private names, credentials, customer data, internal URLs, account IDs, tenant IDs, incident transcripts, or proprietary code into the skill or a public example.

## Load These Files

Read only what the task needs:

| File | Use |
| --- | --- |
| `reference/artifact-model.md` | Required cockpit artifacts, ownership, and content rules |
| `reference/workflows.md` | Review, HITL merge, rollout, tracker, incident, and context workflows |
| `reference/sanitization.md` | Public-safe collection, redaction, and publication checks |
| `scripts/scaffold_cockpit.py` | Create a non-destructive cockpit skeleton |
| `scripts/verify_cockpit.py` | Check structure, metadata, links, catalog coverage, and public-safety patterns |

## Trigger Boundary

Use this skill for programs where one or more of these are true:

- Work spans repositories, teams, environments, or control planes.
- Source merge and operational rollout are separate.
- Pull requests form an ordered train or dependency graph.
- Safety depends on exact heads, migration order, state handoffs, feature flags, or rollback windows.
- Fresh agents repeatedly rebuild context or lose decisions.
- The user wants a central context store, standing orders, execution ledger, or phase tracker.

Do not use it for a single small PR, a static architecture document, or ordinary project notes.

## Core Model

Separate six kinds of truth:

1. **Decision:** approved scope, policy, accepted risk, or explicit authorization.
2. **Design:** intended architecture, contract, or rollout mechanics.
3. **Source state:** branches, commits, PRs, reviews, checks, and merges.
4. **Control-plane state:** deployments, Terraform, cloud resources, DNS, databases, flags, secrets, queues, or identity systems.
5. **Runtime state:** observed behavior, canaries, logs, metrics, health, and incidents.
6. **Authorization:** a human decision naming the exact action, target, and evidence.

Never use one class as proof of another. A merged PR is not a deployment. A reviewed plan is not an apply. Green CI is not merge authorization. A document marked current is not live runtime evidence.

## Procedure

### 1. Establish the Program Boundary

Identify:

- Program objective and explicit non-goals
- Repositories and live default branches
- Environments, tenants, accounts, regions, customers, or deployment targets
- Source authorities and precedence by claim type
- Current phase and phase exit criteria
- Protected actions and who may authorize them
- Existing trackers, RFCs, runbooks, incident records, and handoffs
- Supported local-development flows

Start read-only. Treat every copied document, PR description, and handoff as a lead until refreshed.

If the user has not chosen where the cockpit lives, ask one short question. Recommend a documentation-only branch or repository that cannot be merged into product code by accident.

### 2. Create an Isolated Worktree

Follow the host repository's worktree policy. Do not edit a default-branch checkout.

Use the scaffolder only after confirming the target directory:

```bash
python3 <SKILL_DIR>/scripts/scaffold_cockpit.py \
  --root /absolute/path/to/cockpit \
  --program "Example Migration" \
  --phase "Phase 1"
```

The script refuses to overwrite files unless `--force` is passed. Do not use `--force` without reviewing every collision.

### 3. Build the Authority Map

Write `current/context-map.md` before copying source prose. For each claim type, name:

- Governing source
- Live verification source
- Refresh rule
- Authority limit

Use claim-specific precedence. Architecture approval, current PR state, deployed state, runtime health, and action authorization should not share one vague global ordering.

### 4. Inventory Before Summarizing

Build:

- Repository and dependency map
- Environment/target inventory with aliases
- Decision register
- Risk/finding/deferral register
- Ownership and escalation register
- Artifact catalog and supersession chains

Unknowns must be visible. Never fill a gap with an inferred value.

### 5. Write Standing Orders

Standing orders govern every agent action. At minimum require:

- Exact-head safety verification before merge advice
- Approval status shown before feedback analysis
- `MERGE-SAFE` or `DO NOT MERGE` advice with evidence
- Explicit human authorization after advice and before agent merge
- Separate authorization for deploy, apply, activation, rollback retirement, and deletion
- A rollout contract for every merge, including “dormant code only”
- Immediate warning and deployment freeze when merged rollout obligations are incomplete
- Local-development compatibility as a merge and rollout gate
- One active phase tracker
- Bounded task packets and checkpointed handoffs
- Incident-derived guardrails that remain until repository-enforced controls replace operator memory

### 6. Separate Durable and Volatile State

Durable documents hold rules, architecture, decisions, risks, ownership, and procedures.

The active phase tracker and rollout ledger hold volatile state with:

- Exact PR/head/base or artifact/plan identifiers
- Observation time and source
- Reviewer approval and reviewed commit
- Current-head relationship and semantic delta
- CI and unresolved findings
- Source/deploy/apply/activation/soak/retirement/deletion as separate fields
- Safety state: safe now, safe to roll out, expected safe after rollout, was safe, or unsafe/unknown
- Warning/freeze history
- Next safe action and authorization needed

Never put unqualified present-tense PR or environment claims into durable architecture documents.

### 7. Build the Active Tracker

Track the entire program at a high level and the active phase in detail.

For each phase record:

- Goal
- Deliverables and ordered steps
- Dependencies
- Source status
- Rollout status
- Exit criteria
- Open findings and decisions
- Next action

For every PR, lead with review state:

1. Approved, changes requested, commented only, or no review
2. Reviewer and reviewed commit
3. Current head and functional/non-functional/unknown delta
4. Feedback disposition
5. Remaining CI, dependency, rollout, safety, and authorization gates

Do not request duplicate review solely because a SHA changed. Reviewer approval may continue only when repository policy preserves it and the complete delta is semantically equivalent. Current-head CI, safety advice, and explicit merge authorization still apply.

### 8. Couple Merge and Rollout

Every merge gets a rollout contract:

- Pre-merge steps
- Routine systems that can consume merged default-branch state
- Deployment, migration, state import, secret, DNS, flag, activation, validation, soak, rollback, retirement, and deletion steps
- Owners and separate authorizers
- Evidence and terminal state

Never merge a latent-destructive intermediate state. For example, do not remove a resource from one Terraform owner before the destination state owns it and both real-state plans prove the transfer safe. If a handoff blocks after merge, warn immediately and freeze every routine apply that can consume the state.

### 9. Preserve Local Development

Document supported local startup, auth/emulation, database setup, callbacks, tests, and CLI flows. Changes must not require protected credentials or mutate shared systems for normal local work.

Unknown local impact blocks the responsible change. An intentional local-flow replacement needs an explicit decision, migration instructions, owner, and effective date.

### 10. Control Context Size

Every action uses a compact packet:

- Objective and completion condition
- Repositories, PRs, files, and environment
- Exact state and timestamp
- Relevant standing-order sections and contracts
- Dependencies and rollout obligations
- Findings and evidence links
- Human decision needed
- Next action

Do not preload the entire cockpit. Use targeted sections, exact diffs, and source links. Before context exhaustion, update the packet, tracker, and ledger so another agent can continue without rediscovery.

### 11. Publish External Trackers Carefully

If the user requests a Notion tracker:

1. Read the connected platform's Markdown/content specification first.
2. Create it private and standalone unless the user names a parent.
3. Put a generated notice and refresh date at the top.
4. Cover all phases, active detail, source precedence, evidence limitations, warnings, and update protocol.
5. Link the old tracker to the new tracker; preserve old content as history.
6. Fetch both pages after writing to verify placement.

Do not put secrets, raw plans/state, customer-sensitive data, or full diffs on the page.

### 12. Verify the Cockpit

Run:

```bash
python3 <SKILL_DIR>/scripts/verify_cockpit.py /absolute/path/to/cockpit
```

For a public release, also pass private literals that must not appear:

```bash
python3 <SKILL_DIR>/scripts/verify_cockpit.py /absolute/path/to/cockpit \
  --forbid 'private-company-name' \
  --forbid 'internal.example.com'
```

Then perform a read-only independent audit for contradictions, stale claims, missing rollout state, broken links, and weak stop conditions.

The helper scripts require Python 3.9 or newer. Resolve `<SKILL_DIR>` from the loaded skill location; do not assume the user's working directory is the skill directory.

## Completion Standard

A cockpit is complete when a fresh operator can answer, without guessing:

- Why the program exists and what is out of scope
- Which source governs each claim
- What phase is active and what blocks exit
- What is merged, deployed, applied, activated, soaked, retired, and deleted
- Which PRs are approved and for which commits
- What rollout obligations remain after each merge
- Which actions are safe now, safe next, or unsafe/unknown
- Who owns, authorizes, validates, and rolls back each protected action
- Which incident controls and deployment freezes are active
- How local development remains supported
- Where the compact handoff packet and live evidence are stored

If any answer requires reconstructing history from scratch, the cockpit is not done.
