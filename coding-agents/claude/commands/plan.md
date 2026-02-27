---
description: Create or find a plan with locality-first storage
argument-hint: [topic]
allowed-tools: Read, Write, Edit, Glob, Bash(git rev-parse:*), Bash(git ls-files:*), Bash(ls:*)
---

## Session context

- Working directory: !`pwd`
- Git repo root: !`git rev-parse --show-toplevel 2>/dev/null || echo "none"`
- Project name: !`basename "$(git rev-parse --show-toplevel 2>/dev/null || pwd)"`

## Existing plans (all levels)

!`
set +e
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
CWD=$(pwd)
PROJECT=$(basename "${REPO_ROOT:-$CWD}")
found_any=false

check_dir() {
  local label="$1"
  local dir="$2"
  if [ -d "$dir" ] && [ "$(ls -A "$dir" 2>/dev/null)" ]; then
    echo "### $label"
    echo "Path: $dir"
    ls "$dir"
    echo ""
    found_any=true
  fi
}

# Level 1a — git repo root (preferred)
if [ -n "$REPO_ROOT" ]; then
  check_dir "Level 1a — project repo root (claude)" "$REPO_ROOT/.claude/plans"
  check_dir "Level 1a — project repo root (opencode)" "$REPO_ROOT/.opencode/plans"
fi

# Level 1b — cwd fallback (skip if same as repo root)
if [ -z "$REPO_ROOT" ] || [ "$REPO_ROOT" != "$CWD" ]; then
  check_dir "Level 1b — cwd (claude)" "$CWD/.claude/plans"
  check_dir "Level 1b — cwd (opencode)" "$CWD/.opencode/plans"
fi

# Level 2 — user config
check_dir "Level 2 — user (claude)" "$HOME/.claude/plans/$PROJECT"
check_dir "Level 2 — user (opencode)" "$HOME/.config/opencode/plans/$PROJECT"

# Level 3 — system config
check_dir "Level 3 — system (claude)" "/etc/claude/plans/$PROJECT"
check_dir "Level 3 — system (opencode)" "/etc/opencode/plans/$PROJECT"

if [ "$found_any" = false ]; then
  echo "(no existing plans found)"
fi
`

## Your task

$ARGUMENTS

**Plan storage rules — follow exactly when saving:**

1. **Resolve the save target** using this precedence (first match wins):
   - `<git-repo-root>/.claude/plans/` if in a git repo and this directory exists
   - `<git-repo-root>/.opencode/plans/` if in a git repo and this directory exists
   - `<cwd>/.claude/plans/` if this directory exists
   - `<cwd>/.opencode/plans/` if this directory exists
   - `~/.claude/plans/<project>/` if this directory exists
   - `~/.config/opencode/plans/<project>/` if this directory exists
   - **If none exist:** create `<git-repo-root>/.claude/plans/` (or `<cwd>/.claude/plans/` if not in a repo)

2. **Sensitive override — always use level 2** (`~/.claude/plans/<project>/`) if the plan contains any of:
   - API keys, tokens, passwords, or secrets (even as placeholders)
   - Internal hostnames, IPs, or network topology
   - Personal credentials or account identifiers
   - Environment-specific paths to non-public infrastructure
   - Database connection strings or internal service URLs

3. **Filename:** kebab-case, 3–6 words from the plan topic. Append `-YYYY-MM-DD` only if a
   file with that name already exists at the target location.

4. **After saving:** report the full resolved path.

---

Create a thorough, actionable plan for the topic above, then save it to the correct location.
