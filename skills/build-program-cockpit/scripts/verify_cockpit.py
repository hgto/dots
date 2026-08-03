#!/usr/bin/env python3
"""Verify cockpit structure, metadata, relative links, catalog coverage, and common secret patterns."""

from __future__ import annotations

import argparse
import re
import sys
import datetime as dt
from pathlib import Path


REQUIRED = {
    "AGENTS.md",
    "README.md",
    "STATUS.md",
    "ARTIFACTS.md",
    "VERIFICATION.md",
    "current/standing-orders.md",
    "current/GOVERNANCE.md",
    "current/context-map.md",
    "current/environment-inventory.md",
    "current/decision-register.md",
    "current/ownership-and-escalation.md",
    "current/risk-register.md",
    "current/local-development-contract.md",
    "current/architecture.md",
    "current/implementation-plan.md",
    "current/phase-current-tracker.md",
    "current/phase-rollout-ledger.md",
    "operations/cold-start.md",
    "operations/live-state.md",
    "operations/context-discipline.md",
    "operations/agentic-code-review.md",
    "operations/code-review-response.md",
    "operations/agentic-merge-deploy.md",
    "operations/execution-ledger-template.md",
    "operations/environment-migration-runbook.md",
}

ALLOWED_STATUS = {"current", "outdated"}

LINK_RE = re.compile(r"(?<!!)\[[^\]]*\]\(([^)]+)\)")
CATALOG_PATH_RE = re.compile(r"\]\(([^)#?]+\.md)(?:#[^)]+)?\)")
SECRET_PATTERNS = {
    "private key": re.compile(r"-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----"),
    "AWS access key": re.compile(r"\b(?:AKIA|ASIA)[A-Z0-9]{16}\b"),
    "JWT-shaped value": re.compile(r"\beyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\b"),
    "GitHub token": re.compile(r"\bgh[opsu]_[A-Za-z0-9]{20,}\b"),
}


def frontmatter(text: str) -> dict[str, str]:
    if not text.startswith("---\n"):
        return {}
    end = text.find("\n---\n", 4)
    if end < 0:
        return {}
    values: dict[str, str] = {}
    for line in text[4:end].splitlines():
        if ":" in line:
            key, value = line.split(":", 1)
            values[key.strip()] = value.strip()
    return values


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("root", type=Path)
    parser.add_argument("--forbid", action="append", default=[])
    args = parser.parse_args()

    root = args.root.expanduser().resolve()
    errors: list[str] = []
    warnings: list[str] = []
    all_files = sorted(path for path in root.rglob("*") if path.is_file())
    files = [path for path in all_files if path.suffix.lower() == ".md"]
    rels = {path.relative_to(root).as_posix() for path in files}
    metadata: dict[str, dict[str, str]] = {}

    for required in sorted(REQUIRED - rels):
        errors.append(f"missing required artifact: {required}")

    for path in files:
        rel = path.relative_to(root).as_posix()
        text = path.read_text(encoding="utf-8")
        meta = frontmatter(text)
        metadata[rel] = meta
        for key in ("artifact_status", "status_as_of", "artifact_kind", "owner", "revalidation"):
            if key not in meta:
                errors.append(f"{rel}: missing frontmatter key {key}")
        if meta.get("artifact_status") not in ALLOWED_STATUS:
            errors.append(f"{rel}: invalid artifact_status")
        if not meta.get("artifact_kind"):
            errors.append(f"{rel}: empty artifact_kind")
        try:
            dt.date.fromisoformat(meta.get("status_as_of", ""))
        except ValueError:
            errors.append(f"{rel}: invalid status_as_of date")
        if meta.get("revalidation") not in {"required", "not-required"}:
            errors.append(f"{rel}: invalid revalidation value")
        if meta.get("artifact_status") == "outdated" and "superseded_by" not in meta:
            warnings.append(f"{rel}: outdated artifact has no superseded_by")

        for match in LINK_RE.finditer(text):
            raw = match.group(1).strip()
            if raw.startswith(("http://", "https://", "mailto:", "#", "<")):
                continue
            target_text = raw.split("#", 1)[0].split("?", 1)[0]
            if not target_text:
                continue
            target = (path.parent / target_text).resolve()
            try:
                target.relative_to(root)
            except ValueError:
                warnings.append(f"{rel}: relative link leaves cockpit: {raw}")
                continue
            if not target.exists():
                errors.append(f"{rel}: broken relative link: {raw}")

    for path in all_files:
        rel = path.relative_to(root).as_posix()
        if path.suffix.lower() in {".png", ".jpg", ".jpeg", ".gif", ".pdf", ".zip"}:
            warnings.append(f"{rel}: binary artifact requires manual sanitization review")
            continue
        try:
            text = path.read_text(encoding="utf-8")
        except (UnicodeDecodeError, OSError):
            warnings.append(f"{rel}: unreadable artifact requires manual sanitization review")
            continue
        for name, pattern in SECRET_PATTERNS.items():
            if pattern.search(text):
                errors.append(f"{rel}: possible {name}")
        lowered = text.casefold()
        for index, literal in enumerate(args.forbid, start=1):
            if literal.casefold() in lowered:
                errors.append(f"{rel}: forbidden literal #{index} present")

    catalog_path = root / "ARTIFACTS.md"
    if catalog_path.exists():
        catalog = catalog_path.read_text(encoding="utf-8")
        cataloged = {
            (catalog_path.parent / match.group(1)).resolve().relative_to(root).as_posix()
            for match in CATALOG_PATH_RE.finditer(catalog)
            if (catalog_path.parent / match.group(1)).resolve().is_relative_to(root)
        }
        expected = rels - {"ARTIFACTS.md"}
        for missing in sorted(expected - cataloged):
            errors.append(f"ARTIFACTS.md: retained Markdown file not cataloged: {missing}")

    tracker_artifacts = [
        rel for rel, meta in metadata.items() if meta.get("artifact_kind") == "phase-tracker"
    ]
    active_trackers = [
        rel for rel in tracker_artifacts if metadata[rel].get("artifact_status") == "current"
    ]
    if active_trackers != ["current/phase-current-tracker.md"]:
        errors.append("expected exactly one current phase-tracker artifact at current/phase-current-tracker.md")
    if metadata.get("current/phase-current-tracker.md", {}).get("artifact_kind") != "phase-tracker":
        errors.append("current/phase-current-tracker.md must use artifact_kind: phase-tracker")
    for rel in tracker_artifacts:
        if rel != "current/phase-current-tracker.md" and metadata[rel].get("artifact_status") == "current":
            errors.append(f"additional current phase tracker: {rel}")

    sha_re = re.compile(r"\b[0-9a-f]{40}\b")
    for path in files:
        rel = path.relative_to(root).as_posix()
        if rel.startswith("current/") and "tracker" not in rel and "ledger" not in rel:
            if sha_re.search(path.read_text(encoding="utf-8")):
                warnings.append(f"{rel}: durable current artifact contains a full commit SHA")

    for warning in warnings:
        print(f"WARNING: {warning}")
    for error in errors:
        print(f"ERROR: {error}")
    print(f"Checked {len(files)} Markdown artifacts under {root}")
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
