---
name: language-tooling
description: Verify Swift, Rust, or TypeScript changes with the repository's compiler and language tooling when editor language-server operations are unavailable.
---

Inspect the repository's package manifests and existing verification commands.
Use its configured compiler and package manager rather than installing a
different toolchain. Typical checks are `cargo check` for Rust, `swift build`
for Swift packages, and the existing TypeScript typecheck script or local
`tsc --noEmit` command.

Use host language-server tools for definitions, references, rename, or diagnostics
when they are actually exposed. Claude Code's `lspServers` plugin manifests are
not Codex tool registrations. A compiler check does not provide equivalent
interactive language-server functionality; state that limitation when it matters.

Do not run a bare `npx tsc` that could download an unrelated package. Do not
install global language servers merely to claim parity when the host cannot
expose them as tools.
