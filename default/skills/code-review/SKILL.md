---
name: code-review
description: Review a branch diff for actionable correctness and regression bugs without editing or publishing. Also supplies the correctness pass used by the settle workflows.
---

Identify the repository, branch, full HEAD SHA, working-tree status, intended
base, and merge base. Read the complete scoped diff and the surrounding callers,
contracts, and relevant tests. Include uncommitted changes when requested and
identify that scope explicitly.

Report concrete bugs introduced by the change, with file and line, triggering
inputs or conditions, observable impact, and a scoped recommendation. Check
error paths, authorization-sensitive behavior, compatibility, state transitions,
concurrency, and recovery when relevant. Distinguish confirmed bugs from missing
evidence; do not report speculative style preferences as defects.

Return findings and the exact scanned SHA to the caller. If no actionable
findings remain, say so and state any material verification limits. Remain
read-only: do not edit, commit, push, post comments, or submit a GitHub review.
Use connected GitHub tools or an SSH Git checkout to read code, never `gh` for
code contents.
