# Cockpit Workflows

## Exact-Head Review and HITL Merge

1. Fetch the live destination, PR head/base, commits, diff, reviews, threads, checks, and queue rules.
2. State reviewer approval first: decision, reviewer, reviewed commit, current head, and semantic delta.
3. Review the complete current diff and cross-repository contracts.
4. Verify local development and rollout safety.
5. Issue `MERGE-SAFE` or `DO NOT MERGE` for the current exact head.
6. Wait for explicit human authorization naming the PR and current head.
7. Recheck all state immediately before acting.
8. Merge through the protected path.
9. Verify the destination commit and update tracker/ledger before another action.

Reviewer approval can carry across a non-functional reconstruction only when repository policy keeps it effective and the complete delta preserves reviewed behavior, tests, controls, dependencies, and rollout. Current-head CI, safety advice, and merge authorization never carry implicitly.

## Rollout Contract

For every PR record:

- What changes at source merge
- Whether code remains dormant
- Required pre-merge state operations
- Every routine system that may consume the merged branch
- Deploy/apply/activation order
- Validation and rollback
- Owner and separate authorizer
- Deadline and terminal state

Warn immediately when a merged obligation is incomplete. Name the merged commit, resource/environment, blocked step, latent failure, owner, next safe action, and deployment freeze.

## State/Resource Ownership Handoff

For Terraform, database, DNS, secret, queue, or identity ownership changes:

1. Record source and destination owners and live identifiers.
2. Back up state or prove recovery.
3. Block every routine mutation path touching either owner.
4. Complete destination import/adoption on real state.
5. Require destination no-op plan.
6. Release source state without deleting the live resource.
7. Require source no-delete/no-unrelated-change plan.
8. Verify the live resource externally and through the control plane.
9. Merge only after the merged branch is safe under routine apply.
10. Keep an append-only warning/freeze history until repository-enforced controls close the class.

Never accept an empty/mock-state plan or source-code lifecycle string as proof of existing-state behavior.

## Code Review Response

1. Fetch the full thread and complete current diff.
2. Lead with approval state and reviewed commit.
3. Classify each comment: fix, already fixed, clarification, disagreement, superseded, or approved/optional.
4. Verify the proposed response against code and tests.
5. Do not say fixed based only on a push.
6. Resolve only after verified disposition or reviewer acceptance.
7. Update safety advice, tracker, and rollout state when the head or scope changes.

Thread resolution is not merge authorization.

## Parent-First Replay

When a PR depends on another PR, land the oldest parent into the live destination first. Then rebuild or replay only the child's owned change onto the resulting destination head. Re-run the complete child diff review, required CI, semantic-equivalence check, and merge authorization. Never merge an aggregate or synthetic dependency branch as a shortcut.

## Phase Tracking

The program tracker covers every phase at high level. The active phase tracker gives ordered detail.

Update after:

- Implementation dispatch
- Review or response
- Head/base/dependency change
- CI/check result
- Merge
- Deploy/apply
- Flag or traffic activation
- Validation/soak/rollback
- Incident or new blocker

Phase exit requires source, rollout, runtime, security, compatibility, soak, rollback, and explicit human exit evidence. Source merge alone is never phase completion.

## Context Packet

Keep one packet per action:

```text
Objective:
Completion condition:
Repositories/PRs/files/environment:
Exact base/head/artifact/plan:
Standing rules and contracts:
Dependencies and rollout obligations:
Approval/review state:
Open findings:
Evidence links and timestamp:
Human decision needed:
Next safe action:
```

Checkpoint before handoff or context exhaustion. Parallel agents get non-overlapping scopes and return verdict, findings, evidence, tests, and next action.

## Incident Language

Separate observed facts from assessment:

- **Observed:** direct logs, control-plane output, runtime behavior, or sourced statements.
- **Reported context:** a named source's causal account.
- **Assessment:** inferred mechanism, with calibrated likelihood/confidence if supplied by the owner.

Do not assign blame, infer intent, make legal claims, or copy sensitive transcripts into the cockpit.
