# Cockpit Artifact Model

Use this model as a minimum. Adapt names to repository conventions, but preserve the separation of durable rules, copied sources, history, and volatile execution state.

## Top Level

| Artifact | Required content |
| --- | --- |
| `README.md` | Purpose, non-code boundary, authority overview, directory map, reading order, current documents, operations, history rules |
| `STATUS.md` | Durable objective, immutable safety boundaries, blocker classes, authorization limits, cold-start checklist |
| `ARTIFACTS.md` | Every retained artifact, source/provenance, status, successor/authority, revision chains, known gaps |
| `VERIFICATION.md` | Completeness verdict, evidence basis, capability matrix, residual preconditions, integrity status |
| `AGENTS.md` | Agent instruction index that loads standing orders and current operating artifacts; never embed dynamic state as instructions |

Every governing Markdown artifact should have front matter:

```yaml
---
artifact_status: current
status_as_of: YYYY-MM-DD
artifact_kind: descriptive-kind
owner: accountable-role
revalidation: required
---
```

Historical artifacts use `artifact_status: outdated` and a resolvable `superseded_by` path or source URL.

## `current/`

| Artifact | Required content |
| --- | --- |
| `standing-orders.md` | Active phase, exact-head safety, HITL merge sequence, rollout contracts, warnings/freezes, context discipline, review responses, tracker lifecycle, stop conditions |
| `GOVERNANCE.md` | Claim-specific precedence and protected-action boundaries |
| `context-map.md` | Claim type to governing source, live source, refresh rule, and authority limit |
| `environment-inventory.md` | Targets and aliases, classification, auth/deploy model, phase, live fields required before action |
| `decision-register.md` | Stable IDs, decisions, authority, consequence, supersession rule |
| `ownership-and-escalation.md` | Durable owners, phase RACI, execution-time roles, delegation, channels, stop/escalation rules |
| `risk-register.md` | Findings, accepted risks, deferrals, incident controls, owner, exact closure evidence |
| `local-development-contract.md` | Supported local flows, invariants, required PR evidence, stop conditions |
| `architecture.md` | Problem, goals/non-goals, target architecture, invariants, trust boundaries |
| `implementation-plan.md` | Phase graph, deliverables, tests, rollout, rollback, exit criteria, amendments |
| Active phase tracker | Ordered PR/work train, review state, dependencies, rollout state, blockers, phase exit |
| Active rollout ledger | Current warnings/freezes, source/deploy/apply/activation dimensions, append-only safety transitions |
| Incident guardrails | Observed facts, assessed cause with sourcing, control failure class, mandatory prevention, closure |

There must be exactly one active detailed phase tracker. On transition, mark the old tracker outdated, move it to history, create the next tracker, and update every index in one change.

## `operations/`

| Artifact | Required content |
| --- | --- |
| `cold-start.md` | Identities, repository/default branch refresh, cross-repo state, migration numbers, evidence classes, brief format |
| `live-state.md` | Live-system locators and active shared ledger |
| `context-discipline.md` | Task packet, read budget, handoff, parallel dispatch, retention rules |
| `agentic-code-review.md` | Exact target, security and tenancy boundaries, migration parity, local dev, rollout review, review verdict |
| `code-review-response.md` | Approval-first triage, complete diff, feedback classification, verification, reply, resolve/update state |
| `agentic-merge-deploy.md` | `MERGE-SAFE`, explicit human authorization, queue behavior, rollout warning/freeze, separate protected actions |
| `execution-ledger-template.md` | Roles, state dimensions, approval, safety advice, rollout contract, findings, append-only transitions |
| `environment-migration-runbook.md` | Packet, preflight, environment tuning, expand, migrate, domain/state branch, rollback, drain/retire, failure handling |

## `external/`

Store only safe point-in-time copies of authoritative sources when offline discoverability is valuable. Every copy needs:

- Source URL/system/title
- Capture timestamp and method
- Source status/version when available
- Limitations
- Copy-only notice

Never copy credentials, tokens, state, private customer data, database dumps, raw plans, or full incident transcripts.

## `history/`

Use separate directories for designs, reviews, operations, and evidence. History is provenance, not an operational queue.

Each historical file must say:

- It is outdated
- It must not be used for current PR/CI/readiness claims
- Its current successor or authority
- Its original source and captured revision

## Dynamic State Schema

Track independently:

- Source merged
- Artifact built
- Application deployed
- Database applied
- Terraform planned/applied
- Identity/control-plane ready
- Secrets/config delivered
- DNS/domain ready
- Routing/traffic activated
- Runtime gates healthy
- Rollback available/retired
- Deletion complete

Each observation needs source, timestamp, observer, target, authorization status, unknowns, and expiry/revalidation trigger.
