#!/usr/bin/env python3
"""Create a non-destructive program-cockpit skeleton."""

from __future__ import annotations

import argparse
import datetime as dt
from pathlib import Path


ARTIFACTS: dict[str, tuple[str, str, tuple[str, ...]]] = {
    "AGENTS.md": (
        "agent-instruction-index",
        "Cockpit Agent Instructions",
        ("Start Here", "Standing Rules", "Active Phase", "Operating Guides", "Safety Boundary"),
    ),
    "README.md": (
        "cockpit-index",
        "{program} Cockpit",
        ("Purpose", "Authority", "Directory Map", "Reading Order", "Current Documents", "Operations", "History"),
    ),
    "STATUS.md": (
        "cockpit-status",
        "{program} Status",
        ("Objective", "Immutable Safety Boundaries", "Durable Blockers", "Authorization Boundaries", "Cold-Start Checklist"),
    ),
    "ARTIFACTS.md": (
        "artifact-catalog",
        "{program} Artifact Catalog",
        ("Inventory Policy", "Current Artifacts", "Source Copies", "Historical Artifacts", "Revision Chains", "Known Gaps"),
    ),
    "VERIFICATION.md": (
        "cockpit-verification",
        "Cockpit Completeness Verification",
        ("Verdict", "Evidence Basis", "Capability Matrix", "Residual Preconditions", "Integrity Status"),
    ),
    "current/standing-orders.md": (
        "standing-orders",
        "Program Cockpit Standing Orders",
        ("Active Phase", "Safety Before Merge", "Human-in-the-Loop Merge", "Merge and Rollout", "Incident Controls", "Context Discipline", "Review Responses", "Tracker Stewardship", "Stop Conditions"),
    ),
    "current/GOVERNANCE.md": (
        "decision-precedence",
        "Decision Precedence",
        ("Precedence by Claim Type", "Durable Boundaries", "Conflict Rule"),
    ),
    "current/context-map.md": (
        "context-map",
        "Context Map",
        ("Source by Claim Type", "Repository Map", "Evidence Classes"),
    ),
    "current/environment-inventory.md": (
        "environment-inventory",
        "Environment and Target Inventory",
        ("Inventory", "Required Live Fields", "Unknowns"),
    ),
    "current/decision-register.md": (
        "decision-register",
        "Decision Register",
        ("Decisions", "Amendment Rule"),
    ),
    "current/ownership-and-escalation.md": (
        "ownership-register",
        "Ownership and Escalation",
        ("Durable Ownership", "Phase RACI", "Execution-Time Roles", "Delegation", "Escalation"),
    ),
    "current/risk-register.md": (
        "risk-and-finding-register",
        "Risk, Finding, and Deferral Register",
        ("Current Register", "Historical Review Disposition", "Closure Rules"),
    ),
    "current/local-development-contract.md": (
        "compatibility-contract",
        "Local Development Compatibility Contract",
        ("Directive", "Supported Flows", "Invariants", "Required Change Evidence", "Stop Conditions"),
    ),
    "current/architecture.md": (
        "architecture",
        "Program Architecture",
        ("Problem", "Goals and Non-Goals", "Target Architecture", "Trust Boundaries", "Invariants", "Failure Modes"),
    ),
    "current/implementation-plan.md": (
        "implementation-plan",
        "Implementation Plan",
        ("Execution Model", "Phase Graph", "Phase Plans", "Tests and Gates", "Rollout", "Rollback", "Risks", "Exit Criteria"),
    ),
    "current/phase-current-tracker.md": (
        "phase-tracker",
        "{phase} Tracker",
        ("Tracker Contract", "Last Refresh", "Ordered Work", "Review State", "Rollout State", "Warnings", "Exit Criteria"),
    ),
    "current/phase-rollout-ledger.md": (
        "active-phase-execution-ledger",
        "{phase} Rollout Ledger",
        ("Active Phase", "Roles", "State Dimensions", "Merge Safety and Rollout Contracts", "Warnings and Freezes", "Safety History", "Next Actions"),
    ),
    "operations/cold-start.md": (
        "operating-guide",
        "Cold Start",
        ("Guardrails", "Scope and Identity", "Repository Truth", "Cross-Repository State", "Applied State", "Cold-Start Brief"),
    ),
    "operations/live-state.md": (
        "live-state-locator",
        "Live State and Handoff Locator",
        ("Coordination Sources", "Live Systems", "Shared Ledger", "State Dimensions"),
    ),
    "operations/context-discipline.md": (
        "operating-guide",
        "Context Discipline",
        ("Task Packet", "Read Budget", "Agent Handoff", "Parallel Dispatch", "Retention", "Stop Condition"),
    ),
    "operations/agentic-code-review.md": (
        "operating-guide",
        "Agentic Code Review",
        ("Review Target", "Approval-First Triage", "Security and Trust", "Migration Parity", "Local Development", "Rollout", "Evidence", "Safety Advisory"),
    ),
    "operations/code-review-response.md": (
        "operating-guide",
        "Code Review Response",
        ("Establish Thread and Approval", "Classify", "Verify", "Reply", "Resolve and Update"),
    ),
    "operations/agentic-merge-deploy.md": (
        "operating-guide",
        "Agentic Merge and Deploy",
        ("Boundaries", "Execution Packet", "Parent-First Replay", "Exact-Head Gate", "HITL Merge", "Protected Actions", "Validate", "Stop Conditions"),
    ),
    "operations/execution-ledger-template.md": (
        "execution-ledger-template",
        "Execution Ledger Template",
        ("Identity", "Roles", "State", "Merge Safety and Rollout Contract", "Safety History", "Findings", "Next Actions"),
    ),
    "operations/environment-migration-runbook.md": (
        "environment-migration-runbook",
        "Environment Migration Runbook",
        ("Open Packet", "Preflight", "Tune Environment", "Expand", "Migrate", "Ownership Transfer", "Rollback", "Drain and Retire", "Failure Handling"),
    ),
    "operations/incident-guardrail-template.md": (
        "incident-derived-guardrail-template",
        "Incident-Derived Guardrail Template",
        ("Evidence Boundary", "Control Failure Class", "Mandatory Prevention", "Active Warning", "Closure"),
    ),
    "external/sources/README.md": (
        "source-copy-index",
        "External Source Copies",
        ("Copy Rules", "Sources", "Capture Limitations"),
    ),
    "history/designs/README.md": ("history-index", "Historical Designs", ("Rule", "Artifacts")),
    "history/reviews/README.md": ("history-index", "Historical Reviews", ("Rule", "Artifacts")),
    "history/operations/README.md": ("history-index", "Historical Operations", ("Rule", "Artifacts")),
    "history/evidence/README.md": ("history-index", "Historical Evidence", ("Rule", "Artifacts")),
}


def render(kind: str, title: str, sections: tuple[str, ...], *, program: str, phase: str, date: str) -> str:
    resolved_title = title.format(program=program, phase=phase)
    lines = [
        "---",
        "artifact_status: current",
        f"status_as_of: {date}",
        f"artifact_kind: {kind}",
        "owner: <OWNER_ROLE>",
        "revalidation: required",
        "---",
        "",
        f"# {resolved_title}",
        "",
        "> TODO: Populate from named authorities and live evidence. Do not infer missing state.",
        "",
    ]
    for section in sections:
        lines.extend((f"## {section}", "", "<TODO>", ""))
    return "\n".join(lines).rstrip() + "\n"


def artifact_catalog(*, program: str, date: str) -> str:
    rows = []
    for rel, (kind, _title, _sections) in ARTIFACTS.items():
        if rel == "ARTIFACTS.md":
            continue
        rows.append(f"| [`{rel}`]({rel}) | current | {kind} | Populate authority and provenance |")
    return "\n".join(
        [
            "---",
            "artifact_status: current",
            f"status_as_of: {date}",
            "artifact_kind: artifact-catalog",
            "owner: <OWNER_ROLE>",
            "revalidation: required",
            "---",
            "",
            f"# {program} Artifact Catalog",
            "",
            "## Inventory Policy",
            "",
            "Retain current governing artifacts once, plus only the historical variants needed to explain decisions. Dynamic claims require live verification.",
            "",
            "## Retained Artifacts",
            "",
            "| Artifact | Status | Kind | Authority / provenance |",
            "| --- | --- | --- | --- |",
            *rows,
            "",
            "## Revision Chains",
            "",
            "<TODO>",
            "",
            "## Known Gaps",
            "",
            "<TODO>",
            "",
        ]
    )


def safe_target(root: Path, rel: str) -> Path:
    target = root / rel
    cursor = root
    for part in Path(rel).parts[:-1]:
        cursor /= part
        if cursor.is_symlink():
            raise ValueError(f"refusing to traverse symlinked directory: {cursor}")
    resolved_parent = target.parent.resolve(strict=False)
    if not resolved_parent.is_relative_to(root):
        raise ValueError(f"refusing to write outside cockpit root: {target}")
    if target.is_symlink():
        raise ValueError(f"refusing to overwrite symlink: {target}")
    return target


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, required=True)
    parser.add_argument("--program", required=True)
    parser.add_argument("--phase", default="Current Phase")
    parser.add_argument("--date", default=dt.date.today().isoformat())
    parser.add_argument("--force", action="store_true")
    args = parser.parse_args()

    root = args.root.expanduser().resolve()
    root.mkdir(parents=True, exist_ok=True)
    try:
        targets = {rel: safe_target(root, rel) for rel in ARTIFACTS}
    except ValueError as exc:
        parser.error(str(exc))
    collisions = [path for path in targets.values() if path.exists()]
    if collisions and not args.force:
        joined = "\n".join(f"  {path}" for path in collisions)
        parser.error(f"refusing to overwrite existing files:\n{joined}")

    for rel, (kind, title, sections) in ARTIFACTS.items():
        target = targets[rel]
        target.parent.mkdir(parents=True, exist_ok=True)
        content = (
            artifact_catalog(program=args.program, date=args.date)
            if rel == "ARTIFACTS.md"
            else render(kind, title, sections, program=args.program, phase=args.phase, date=args.date)
        )
        target.write_text(content, encoding="utf-8")

    print(f"Created {len(ARTIFACTS)} cockpit artifacts under {root}")
    print("Next: populate context-map, standing-orders, inventory, tracker, and ledger from live sources.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
