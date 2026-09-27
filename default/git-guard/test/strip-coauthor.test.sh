#!/usr/bin/env sh
# Tests for the global git-guard hook dispatcher (_chain) and its commit-msg
# behavior: strip Claude/Anthropic co-author trailers, preserve everything else,
# and delegate to any repo-local hook of the same name.
#
# Run: sh default/git-guard/test/strip-coauthor.test.sh
set -u

# shellcheck disable=SC1007  # `CDPATH= cd` clears CDPATH for this command only
HOOKS_DIR="${HOOKS_DIR:-$(CDPATH= cd "$(dirname "$0")/.." && pwd)/hooks}"
COMMIT_MSG_HOOK="$HOOKS_DIR/commit-msg"

_tests=0 _fails=0
ok()   { printf '  ok: %s\n' "$1"; }
fail() { _fails=$((_fails + 1)); printf 'FAIL: %s\n' "$1" >&2; }
check(){ _tests=$((_tests + 1)); }

SANDBOX=""
sandbox() { cleanup; SANDBOX=$(mktemp -d); }
cleanup() { [ -n "$SANDBOX" ] && rm -rf "$SANDBOX"; SANDBOX=""; }
trap cleanup EXIT

newrepo() {
  repo="$SANDBOX/repo"; mkdir -p "$repo"
  git -C "$repo" init -q
  git -C "$repo" config core.hooksPath "$HOOKS_DIR"
  git -C "$repo" config user.email t@example.com
  git -C "$repo" config user.name  T
  git -C "$repo" config commit.gpgsign false
  printf '%s' "$repo"
}

# --- 1: strips the Claude trailer, preserves subject + body ---
sandbox
f="$SANDBOX/msg"
printf 'feat: thing\n\nbody line\n\nCo-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>\n' > "$f"
"$COMMIT_MSG_HOOK" "$f"
check; if grep -qi anthropic "$f"; then fail "Claude trailer not stripped"; else ok "strips Claude co-author trailer"; fi
check; if grep -q '^feat: thing' "$f" && grep -q 'body line' "$f"; then ok "preserves subject and body"; else fail "subject/body damaged"; fi
check; if [ "$(tail -n1 "$f")" = "" ]; then fail "left a dangling trailing blank line"; else ok "no dangling trailing blank line"; fi

# --- 2: leaves a legitimate human co-author untouched ---
sandbox
f="$SANDBOX/msg"
printf 'fix: bug\n\nCo-authored-by: Jane Dev <jane@example.com>\n' > "$f"
"$COMMIT_MSG_HOOK" "$f"
check; if grep -q 'jane@example.com' "$f"; then ok "keeps human co-author"; else fail "human co-author wrongly stripped"; fi

# --- 3: end-to-end real commit via core.hooksPath ---
sandbox
repo="$(newrepo)"
: > "$repo/a"; git -C "$repo" add a
git -C "$repo" commit -q -m "$(printf 'add a\n\nCo-Authored-By: Claude <noreply@anthropic.com>')"
check; if git -C "$repo" log -1 --format='%B' | grep -qi anthropic; then fail "e2e: trailer survived commit"; else ok "e2e: trailer stripped on real commit"; fi
check; if [ "$(git -C "$repo" log -1 --format='%s')" = "add a" ]; then ok "e2e: subject intact"; else fail "e2e: subject mangled"; fi

# --- 4: delegates to a repo-local commit-msg hook ---
sandbox
repo="$(newrepo)"
mkdir -p "$repo/.git/hooks"
cat > "$repo/.git/hooks/commit-msg" <<'HOOK'
#!/usr/bin/env sh
grep -qi 'WIP' "$1" && { echo "no WIP allowed" >&2; exit 1; }
exit 0
HOOK
chmod +x "$repo/.git/hooks/commit-msg"
: > "$repo/b"; git -C "$repo" add b
check; if git -C "$repo" commit -q -m "WIP: nope" 2>/dev/null; then fail "delegation: repo-local hook not enforced"; else ok "delegates to repo-local commit-msg hook"; fi

# --- 5: strips + delegates when committing from a linked worktree ---
sandbox
repo="$(newrepo)"
: > "$repo/seed"; git -C "$repo" add seed; git -C "$repo" commit -q -m seed
mkdir -p "$repo/.git/hooks"
cat > "$repo/.git/hooks/commit-msg" <<'HOOK'
#!/usr/bin/env sh
grep -qi 'WIP' "$1" && { echo "no WIP allowed" >&2; exit 1; }
exit 0
HOOK
chmod +x "$repo/.git/hooks/commit-msg"
git -C "$repo" worktree add -q "$repo/wt" -b wt
: > "$repo/wt/c"; git -C "$repo/wt" add c
git -C "$repo/wt" commit -q -m "$(printf 'in worktree\n\nCo-Authored-By: Claude <noreply@anthropic.com>')"
check; if git -C "$repo/wt" log -1 --format='%B' | grep -qi anthropic; then fail "worktree: trailer survived"; else ok "worktree: trailer stripped"; fi
printf 'x' > "$repo/wt/d"; git -C "$repo/wt" add d
check; if git -C "$repo/wt" commit -q -m "WIP: nope" 2>/dev/null; then fail "worktree: shared local hook not enforced"; else ok "worktree: delegates to shared .git/hooks"; fi

# --- 6: chained behind another dispatcher — repo-local hook runs exactly once ---
# Stand up a fake gitid-style dispatcher: it walks gitid.prevHooksPath (us) and
# then the repo-local hooks. _chain must NOT also delegate, or the repo-local
# hook fires twice per commit.
sandbox
repo="$(newrepo)"
outer="$SANDBOX/outer"; mkdir -p "$outer"
cat > "$outer/commit-msg" <<OUTER
#!/usr/bin/env sh
set -u
hook=\$(basename "\$0")
prev=\$(git config --get gitid.prevHooksPath 2>/dev/null || true)
gitdir=\$(git rev-parse --absolute-git-dir 2>/dev/null || true)
for dir in "\$prev" "\$gitdir/hooks"; do
  [ -n "\$dir" ] || continue
  [ -x "\$dir/\$hook" ] && "\$dir/\$hook" "\$@"
done
exit 0
OUTER
chmod +x "$outer/commit-msg"
mkdir -p "$repo/.git/hooks"
cat > "$repo/.git/hooks/commit-msg" <<HOOK
#!/usr/bin/env sh
echo tick >> "$SANDBOX/count"
exit 0
HOOK
chmod +x "$repo/.git/hooks/commit-msg"
git -C "$repo" config core.hooksPath "$outer"
git -C "$repo" config gitid.prevHooksPath "$HOOKS_DIR"
: > "$repo/e"; git -C "$repo" add e
git -C "$repo" commit -q -m "$(printf 'chained\n\nCo-Authored-By: Claude <noreply@anthropic.com>')"
check; if [ "$(wc -l < "$SANDBOX/count" | tr -d ' ')" = "1" ]; then ok "chained: repo-local hook runs exactly once"; else fail "chained: repo-local hook ran $(wc -l < "$SANDBOX/count" | tr -d ' ') times, want 1"; fi
check; if git -C "$repo" log -1 --format='%B' | grep -qi anthropic; then fail "chained: trailer survived"; else ok "chained: trailer still stripped"; fi

# --- 7: primary dispatcher still delegates even if prevHooksPath names us ---
# A repo pointing core.hooksPath straight at us is using us as primary. The
# skip in test 6 must not fire here.
sandbox
repo="$(newrepo)"
mkdir -p "$repo/.git/hooks"
cat > "$repo/.git/hooks/commit-msg" <<'HOOK'
#!/usr/bin/env sh
grep -qi 'WIP' "$1" && { echo "no WIP allowed" >&2; exit 1; }
exit 0
HOOK
chmod +x "$repo/.git/hooks/commit-msg"
git -C "$repo" config gitid.prevHooksPath "$HOOKS_DIR"
: > "$repo/f"; git -C "$repo" add f
check; if git -C "$repo" commit -q -m "WIP: nope" 2>/dev/null; then fail "primary: delegation wrongly skipped"; else ok "primary: still delegates when prevHooksPath names us"; fi

# --- 8: gitguard.extraHooksPath hook blocks a commit ---
sandbox
repo="$(newrepo)"
extra="$SANDBOX/extra"; mkdir -p "$extra"
cat > "$extra/commit-msg" <<'HOOK'
#!/usr/bin/env sh
echo "blocked by extra hook" >&2
exit 1
HOOK
chmod +x "$extra/commit-msg"
git -C "$repo" config gitguard.extraHooksPath "$extra"
: > "$repo/g"; git -C "$repo" add g
check; if git -C "$repo" commit -q -m "should be blocked" 2>/dev/null; then fail "extra hook did not block commit"; else ok "extra hook blocks a commit"; fi

# --- 9: gitguard.extraHooksPath hook passes, commit proceeds normally ---
sandbox
repo="$(newrepo)"
extra="$SANDBOX/extra"; mkdir -p "$extra"
cat > "$extra/commit-msg" <<'HOOK'
#!/usr/bin/env sh
exit 0
HOOK
chmod +x "$extra/commit-msg"
git -C "$repo" config gitguard.extraHooksPath "$extra"
: > "$repo/h"; git -C "$repo" add h
check; if git -C "$repo" commit -q -m "fine" 2>/dev/null; then ok "extra hook passing lets commit through"; else fail "extra hook wrongly blocked a passing commit"; fi

# --- 10: pre-push stdin reaches both the extra hook and the repo-local hook ---
sandbox
repo="$(newrepo)"
: > "$repo/seed"; git -C "$repo" add seed; git -C "$repo" commit -q -m seed
extra="$SANDBOX/extra"; mkdir -p "$extra"
cat > "$extra/pre-push" <<EXTRA
#!/usr/bin/env sh
cat > "$SANDBOX/extra-stdin"
exit 0
EXTRA
chmod +x "$extra/pre-push"
mkdir -p "$repo/.git/hooks"
cat > "$repo/.git/hooks/pre-push" <<LOCAL
#!/usr/bin/env sh
cat > "$SANDBOX/local-stdin"
exit 0
LOCAL
chmod +x "$repo/.git/hooks/pre-push"
git -C "$repo" config gitguard.extraHooksPath "$extra"
(cd "$repo" && printf 'refs/heads/main %s refs/heads/main 0000000000000000000000000000000000000000\n' \
  "$(git rev-parse HEAD)" | "$HOOKS_DIR/pre-push" origin "git@example.com:x/y.git")
check; if [ -s "$SANDBOX/extra-stdin" ]; then ok "pre-push stdin reaches the extra hook"; else fail "extra hook got no stdin"; fi
check; if [ -s "$SANDBOX/local-stdin" ]; then ok "pre-push stdin reaches the repo-local hook"; else fail "repo-local hook got no stdin"; fi
check; if [ "$(cat "$SANDBOX/extra-stdin")" = "$(cat "$SANDBOX/local-stdin")" ]; then ok "both hooks see identical stdin"; else fail "stdin diverged between hooks"; fi

# --- 11: no gitguard.extraHooksPath configured is a no-op ---
sandbox
repo="$(newrepo)"
git -C "$repo" config --unset gitguard.extraHooksPath 2>/dev/null || true
: > "$repo/i"; git -C "$repo" add i
check; if git -C "$repo" commit -q -m "no extra path" 2>/dev/null; then ok "unset extraHooksPath is a no-op"; else fail "commit blocked with no extraHooksPath configured"; fi

# --- 12: extra hook also runs when chained behind another dispatcher ---
sandbox
repo="$(newrepo)"
extra="$SANDBOX/extra"; mkdir -p "$extra"
cat > "$extra/commit-msg" <<'HOOK'
#!/usr/bin/env sh
echo "blocked by extra hook" >&2
exit 1
HOOK
chmod +x "$extra/commit-msg"
outer="$SANDBOX/outer"; mkdir -p "$outer"
cat > "$outer/commit-msg" <<OUTER
#!/usr/bin/env sh
set -u
hook=\$(basename "\$0")
prev=\$(git config --get gitid.prevHooksPath 2>/dev/null || true)
gitdir=\$(git rev-parse --absolute-git-dir 2>/dev/null || true)
for dir in "\$prev" "\$gitdir/hooks"; do
  [ -n "\$dir" ] || continue
  [ -x "\$dir/\$hook" ] || continue
  "\$dir/\$hook" "\$@" || exit \$?
done
exit 0
OUTER
chmod +x "$outer/commit-msg"
git -C "$repo" config core.hooksPath "$outer"
git -C "$repo" config gitid.prevHooksPath "$HOOKS_DIR"
git -C "$repo" config gitguard.extraHooksPath "$extra"
: > "$repo/j"; git -C "$repo" add j
check; if git -C "$repo" commit -q -m "should be blocked chained" 2>/dev/null; then fail "chained: extra hook did not block commit"; else ok "chained: extra hook blocks a commit"; fi

printf '\n%d tests, %d failures\n' "$_tests" "$_fails"
[ "$_fails" -eq 0 ]
