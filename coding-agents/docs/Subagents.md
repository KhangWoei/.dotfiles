# Subagents

Comparison of custom agent/subagent definition schemas across Claude Code and OpenCode.

---

## File Format

Both tools use **Markdown files with YAML frontmatter**. The body of the file becomes the system prompt.

```markdown
---
field: value
---

You are a ...
```

---

## Field Reference

| Field | Claude Code | OpenCode | Notes |
|-------|-------------|----------|-------|
| `name` | `my-agent` (required) | not used (filename is the name) | Claude Code: lowercase letters and hyphens |
| `description` | required | required | Shared field, same purpose |
| `model` | `sonnet`, `opus`, `haiku`, `inherit` | `anthropic/claude-sonnet-4-20250514` (full ID) | Same field name, incompatible values |
| `mode` | not supported | `primary`, `subagent`, `all` | OpenCode-only |
| `tools` | `Read, Grep, Glob` (allowlist string/array) | `{write: false, bash: false}` (per-tool booleans) | Same field name, incompatible format |
| `disallowedTools` | `Write, Edit` (denylist) | not supported | Claude Code-only |
| `permissionMode` | `default`, `acceptEdits`, `dontAsk`, `bypassPermissions`, `plan` | not supported | Claude Code-only |
| `permissions` | not supported | `{ask\|allow\|deny}` per tool | OpenCode-only |
| `maxTurns` | integer | not supported | Claude Code-only |
| `steps` | not supported | integer | OpenCode-only |
| `temperature` | not supported | `0.0`–`1.0` | OpenCode-only |
| `top_p` | not supported | `0.0`–`1.0` | OpenCode-only |
| `skills` | array of skill names | not supported | Claude Code-only |
| `mcpServers` | object | not supported | Claude Code-only |
| `hooks` | object | not supported | Claude Code-only |
| `memory` | `user`, `project`, `local` | not supported | Claude Code-only |
| `background` | boolean | not supported | Claude Code-only |
| `isolation` | `worktree` | not supported | Claude Code-only |

---

## Storage Locations

### Claude Code

| Priority | Path | Scope |
|----------|------|-------|
| 1 (highest) | `--agents` CLI flag | Session |
| 2 | `.claude/agents/` | Project |
| 3 | `~/.claude/agents/` | User |
| 4 | Plugin `agents/` directory | Plugin |

### OpenCode

| Priority | Path | Scope |
|----------|------|-------|
| 1 | `.opencode/agents/` | Project |
| 2 | `~/.config/opencode/agents/` | User |

---

## Example Agent Files

### Claude Code

```markdown
---
name: code-reviewer
description: Reviews code for quality, security, and maintainability.
tools: Read, Grep, Glob, Bash
disallowedTools: Write, Edit
model: sonnet
permissionMode: default
maxTurns: 10
---

You are a senior code reviewer. When invoked, run `git diff` and review modified files.
```

### OpenCode

```markdown
---
description: Reviews code for quality, security, and maintainability.
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.1
tools:
  write: false
  edit: false
  read: true
  grep: true
  glob: true
---

You are a senior code reviewer. When invoked, run `git diff` and review modified files.
```

