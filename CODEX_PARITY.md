# Codex skill and plugin parity

Implemented locally on November 4, 2026. Global skills and the verified MCP
connections are installed. Repository discovery changes are committed in task
worktrees and have not been merged or pushed.

## Installed

The shared root, `~/.agents/skills`, now contains 60 discoverable skills:
26 existing skills, 30 additional source skills, and four Codex adapters.
Sixteen older AWS skill directories were preserved before replacement.

The 50 activated directories include 19 AWS skills, 11 custom security skills,
three Systems Programming skills, Frontend Design, Auth0, seven Chrome DevTools
skills, OpenCode's Doc Coauthoring and Rust Skills, PR Review Request, Writing
RFCs, and the Worktrees, Code Review, Language Tooling, and Traversal MCP adapters.

`default/codex-parity-sources.json` records each source. Skill directories retain
their supporting references, scripts, assets, and included license files.
Claude Code and OpenCode configuration and skill installations were not changed.
Existing Codex plugin flags, models, providers, hooks, and MCP entries were
preserved.

| Capability | Codex implementation | Verification |
| --- | --- | --- |
| AWS Core | Updated shared skills and existing AWS MCP | Skill discovery; dedicated AWS documentation server exposes 5 tools |
| Slack | Existing native Slack plugin | Existing installation retained |
| Terraform | Pinned Terraform MCP 0.4.0 | Initialization and 9 public registry tools; no Terraform account token supplied |
| Custom Security Skills | Ported 11-skill collection | Manifests and discovery pass; correctness-review dependency supplied |
| Claude Security | Existing native Codex Security | Existing installation retained; Claude's harness was not copied |
| Frontend Design | Shared skill | Manifest and discovery pass |
| Playwright | Pinned Playwright MCP package 0.0.84 | Initialization and 25 tools |
| Chrome DevTools | Pinned MCP 1.11.0 and seven skills | Initialization and 32 tools |
| Systems Programming | Three shared skills | Manifest and discovery pass; Claude agent-role registrations are host-specific |
| Auth0 | Shared skill and public Auth0 Docs MCP | Public MCP initialization succeeds |
| Swift, Rust, TypeScript LSP | Language Tooling adapter | Compiler-based fallback documented; native interactive LSP parity remains unavailable |
| Linear | Direct OAuth MCP | Keychain login succeeds; live Codex inventory exposes 84 tools |
| 1Password | Official bundled MCP executable | Required guides read; tool schemas inspected; authentication and Environment mount metadata succeed |

Browser servers use isolated profiles. Package versions are pinned.
MCP OAuth credentials use macOS Keychain through
`mcp_oauth_credentials_store = "keyring"`. No resolved secret was written to a
configuration, argument, temporary file, or artifact. The inaccessible
`/usr/local/bin/1password-mcp` alias was left untouched; Codex uses the official
binary inside `/Applications/1Password.app`.

## Pending integrations

- Traversal: 1Password confirms an enabled mount for the expected Environment,
  and the mount is a FIFO, but its read timed out. The adapter is installed and
  its configuration is disabled. It was not possible to verify a live Traversal
  connection. Repair the mount through the official 1Password MCP before enabling
  `mcp_servers.traversal`; never substitute a regular file or exported key.
- GitHub MCP: the endpoint rejected dynamic OAuth client registration. Its new
  direct entry remains disabled. SSH Git access works and remains the code-read
  path. No personal access token was requested or exported.
- Wiz: OAuth waited for user interaction and timed out. Its entry remains
  disabled. Complete login through Codex with Keychain storage before enabling it.
- Google Calendar: Claude's separate `@cocal/google-calendar-mcp` integration was
  inventoried but not ported. A secret-manager-backed credential path needs to be
  established before installing its OAuth credential flow.
- Claude's Swift, Rust, and TypeScript LSP plugin registrations and specialized
  agent-role registrations do not map directly to Codex tools.

Claude's seven installed but not explicitly enabled plugins were excluded from
this rollout: Notion, Superpowers, Static Analysis, Comprehensive Review, Supply
Chain Risk Auditor, Skill Creator, and Linear. The existing Codex Notion and
Linear configuration was preserved; the working direct Linear connection is
additional. No host-specific Claude hook or security harness was installed.

## Repository changes

Each task worktree adds only `.agents/skills -> ../.claude/skills`, preserving
repository scope and the existing canonical skill content.

| Repository | Skills exposed | Worktree | Commit |
| --- | --- | --- | --- |
| infrastructure | 9 | `infrastructure/.worktrees/codex-skill-parity` | `7cb30bb5e` |
| db-migrations | 5 | `db-migrations/.worktrees/codex-skill-parity` | `c14a1b7` |
| traversal-demo-docker | 3 | `traversal-demo-docker/.worktrees/codex-skill-parity` | `f8544f0` |

These changes are available when working in those task worktrees. They will
apply to the usual checkouts after their normal merge process. Traversal already
has matching Claude and shared skill roots and needed no change. The initial
audit counted four db-migrations skills; fetching the current mainline found five.

Clean repository mainline checkouts were fast-forwarded. Existing dirty
dotfiles and hgto-traversal checkouts were preserved. No setup-worktree script
was run.

## Validation

- The official skill validator passes all 53 manifests in the dotfiles worktree.
- A fresh Codex app-server accepts strict configuration and discovers 75 unique
  skill names from the workspace, with no loading errors. Counts include bundled
  and plugin skills beyond the 60 shared skills.
- Discovery in the three repository task worktrees reports 84, 80, and 78 unique
  skill names respectively, with no loading errors.
- Six behavioral tests pass for the Traversal header helper: regular-file
  rejection, symlink rejection, quoted FIFO value handling, missing-variable
  rejection, malformed-value rejection, and bounded timeout without a writer.
  Tests use public fixtures and never access the real credential.
- Public MCP initialization and tool discovery pass for Playwright, Chrome
  DevTools, Terraform, and AWS Documentation. Auth0 Docs initialization passes.
- Linear's authenticated tool inventory was verified through a fresh Codex
  app-server. No investigation or account mutation was performed.
- The db-migrations commit hook passed using its existing installed environment
  without dependency synchronization. No hook was bypassed.

## Compatibility changes

The ports replace OpenCode-only Skill/Task calls with skill-file loading and
host delegation, provide the missing `code-review` dependency, and replace
Claude-specific Slack tool names and cached reviewer IDs with live discovery.
The worktree skill now discovers the correct mainline branch and explicitly
creates worktrees instead of assuming `main` or Claude's isolation API.

Unsupported AWS frontmatter versions were moved under `metadata`; one oversized
description was shortened. Auth0 discovery is scoped to Auth0 projects or
requests. Relative reference links were corrected where their targets were
already present. Existing user authorization is respected when writing RFCs.
The source PR security workflow's `gh api` code-read example was replaced with
SSH Git or connected GitHub tools, as required by workspace instructions.

The shared worktree guide still shows `main` in examples, while the actual
repositories use `main` or `master`. The new adapter follows the checked-out
repository and configured upstream. This existing documentation inconsistency
was not changed.

Imported Go examples retain their conventional tab indentation despite the
dotfiles repository's generic `tab-in-indent` whitespace setting. Standard
trailing-space, final-blank-line, and space-before-tab checks apply to the
snapshot. Rust's repository metadata and unrelated contributor documentation
were excluded; its skill, rule references, checks, and license are retained.

## Persistence and rollback

Active shared-skill symlinks point into the dotfiles task worktree at
`/Users/thug/Projects/the_product/.worktrees/codex-parity-dots`.
Keep it until the changes are merged and links are repointed to the permanent
checkout. Removing it now would break the newly installed skills.

`~/.agents/codex-parity-install.json` records installed links, original skill
backup locations, added MCP entries, and the previous OAuth-store setting.
The 16 preserved AWS directories are under
`~/.agents/skill-backups/codex-parity-20261104/`.

To roll back, remove only skill symlinks that still match the manifest, then
restore their recorded backup directories. Remove only the ten added MCP
tables and restore the prior OAuth-store setting if appropriate; preserve
unrelated configuration and do not export Keychain credentials. Unmerged
repository commits can simply remain unmerged. Restart Codex to reload MCP
servers; skills are available on the next turn.
