---
name: plan-saving
description: >
  Use this skill whenever an agent needs to save or retrieve a plan file. This skill provides a
  deterministic, locality-first strategy for plan storage and retrieval: plans live as close to the
  project as possible and are named to reflect their content. Trigger when creating, writing, or
  looking up any plan — even if the user just says "save this plan" or "find the plan for X".
---

# Plan Saving

When saving or retrieving a plan, **always follow the locality-first hierarchy** — prefer the most
project-local location and fall back to wider scopes only when necessary.

---

## Directory Hierarchy

### Saving a plan (most local → most global)

| Priority | Claude path | OpenCode path | Notes |
|----------|-------------|---------------|-------|
| 1a (repo root) | `<git-root>/.claude/plans/` | `<git-root>/.opencode/plans/` | Git repo root; highest priority when inside a repo |
| 1b (cwd) | `<cwd>/.claude/plans/` | `<cwd>/.opencode/plans/` | Fallback when not in a repo, or repo root == cwd |
| 2 (user) | `~/.claude/plans/<project>/` | `~/.config/opencode/plans/<project>/` | User-space with project subfolder |
| 3 (system) | `/etc/claude/plans/<project>/` | `/etc/opencode/plans/<project>/` | System-wide; rarely used |

**Selection rule:**
1. If inside a git repo: check `<git-repo-root>/.claude/plans/` (or `.opencode/plans/`) first.
2. If no repo, or that directory doesn't exist: check `<cwd>/.claude/plans/`.
3. Fall through to level 2, then level 3.
4. If none found: **create at level 1a** (git root when in a repo, else cwd).

**Exception:** If writing to level 1 would commit sensitive data to version control, fall back to
level 2 (user config).

### Finding existing plans (same hierarchy, read direction)

Search level 1a → 1b → 2 → 3 and return the first match. If matches exist at multiple levels,
prefer the most-local one and note that others exist.

---

## Project Folder Derivation (Levels 2 & 3)

When saving at user or system scope, the `<project>` subdirectory is derived by:

1. **Git repo root name** — `basename $(git rev-parse --show-toplevel)` if inside a git repo
2. **Working directory name** — `basename $PWD` if not in a git repo
3. **Create the folder** if it does not exist

Example: working in `/home/user/work/my-api` inside a git repo → saves to `~/.claude/plans/my-api/`

---

## Sensitive Plan Detection

Always redirect to **level 2 (user config)** if the plan contains any of the following:

- API keys, tokens, passwords, or secrets (even as examples or placeholders)
- Internal hostnames, IP addresses, or network topology details
- Personal credentials or account identifiers
- Environment-specific paths pointing to non-public infrastructure
- Database connection strings or internal service URLs

**Never save sensitive plans at level 1** — they could be committed to a public repository.

---

## File Naming Protocol

### Derive from context

- Convert the plan's main topic/goal to **kebab-case**
- Keep it short: **3–6 words**
- Examples: `add-auth-middleware.md`, `refactor-database-layer.md`, `fix-login-redirect.md`

### Disambiguation

| Situation | Action |
|-----------|--------|
| Topic is vague or name collision is likely | Append ISO date suffix: `add-caching-2026-02-27.md` |
| Still ambiguous **and** session is interactive | Prompt the user to confirm or supply the filename |
| Still ambiguous **and** session is non-interactive | Generate best-effort name, log it clearly so the user can rename later |

### Fallback

If no meaningful name can be derived: `plan-<ISO-date>.md`

---

## Step-by-Step Protocol

```
1. Determine the target agent (Claude or OpenCode) from context.

2. Detect git repo root:
   REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)

3. Walk the hierarchy to find an existing plans/ directory:
   a. Check <git-repo-root>/.claude/plans/   (or .opencode/plans/) — if in a git repo
   b. Check <cwd>/.claude/plans/             (or .opencode/plans/) — fallback
   c. Check ~/.claude/plans/                 (or ~/.config/opencode/plans/)
   d. Check /etc/claude/plans/               (or /etc/opencode/plans/)

4. If found at level a or b → save there directly.
   If found at level c or d → derive <project> name (git root or cwd basename),
     save to <level>/<project>/
   If none found → create <git-repo-root>/.claude/plans/ (or <cwd>/.claude/plans/ if not
     in a repo) and save there — unless the plan is sensitive (see above), in which case
     create level c instead.

5. Check for sensitive content (see Sensitive Plan Detection). If detected, redirect to level c.

6. Derive the filename:
   - Summarize plan topic in kebab-case, 3–6 words.
   - Check for name collision in the target directory.
   - Disambiguate with ISO date or user prompt as needed.
   - Fallback: plan-<ISO-date>.md

7. Write the plan file.

8. Report the full path to the user.
```

---

## Decision Flowchart

```
Need to save a plan
        │
        ▼
  Plan is sensitive?
  (secrets, credentials, internal hosts)
        │
   Yes──┘  No
   │        │
   ▼        ▼
Use      In a git repo?
level 2       │
         Yes──┘  No
         │        │
         ▼        ▼
   plans/ at    plans/ at
   git root?      cwd?
        │            │
   Yes──┘  No   Yes──┘  No
   │        │   │        │
   ▼        ▼   ▼        ▼
 Save   check  Save   check
 there  cwd   there  level 2 → level 3
              ──────────────────────────
                   if none, create 1a
```

---

## Notes

- **Always report the full path** after saving so the user knows exactly where the plan lives.
- The git repo root takes priority over cwd so plans are consistently placed at the project root
  even when working in a subdirectory.
- Plans at level 1 may be committed to version control — desirable for team-shared plans, but
  never when the plan contains credentials or environment-specific secrets.
- When retrieving a plan, if the user gives only a partial name (e.g., "the auth plan"), search
  all levels and list matches before opening one.
