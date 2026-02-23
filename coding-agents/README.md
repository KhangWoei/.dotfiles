# Coding Agents Configuration

Dotfiles for configuring AI coding agents (Claude Code and Opencode). Configurations are symlinked to their expected locations on the system.

## Project Structure

```
coding-agents/
├── claude/
│   └── settings.json              # Global Claude settings → symlink to ~/.claude/settings.json
├── .claude/
│   └── settings.local.json        # Project-level Claude permissions for this repo
├── skills/
│   └── markdown-first-fetch/      # Custom skill: markdown-aware web fetching
│       └── SKILL.md
└── opencode/
    ├── opencode.json              # Opencode project config (permissions)
    └── agents/
        ├── orchestrator.md        # Primary router — delegates to subagents
        ├── planner.md             # Requirements gathering and task breakdown
        ├── debugger.md            # Read-only bug investigation
        ├── docs.md                # Documentation writer
        └── reviewer.md            # Read-only code review
```

---

## Claude Configuration Precedence

Like git, Claude merges configuration from multiple sources in the following order (later entries override earlier ones):

```
Enterprise policy     (/etc/claude/policy.json)         — org-wide managed defaults
Global settings       (~/.claude/settings.json)          — user preferences
Project settings      (.claude/settings.json)            — project-specific settings
Local project         (.claude/settings.local.json)      — machine-local overrides (gitignored)
```

`claude/settings.json` in this repo is intended to be symlinked to `~/.claude/settings.json`.

---

## Opencode Configuration Precedence

Like git, Opencode merges configuration from multiple sources in the following order (later entries override earlier ones):

```
Remote config         (.well-known/opencode)             — organizational defaults
Global config         (~/.config/opencode/opencode.json) — user preferences
Custom config         (OPENCODE_CONFIG env var)           — custom overrides
Project config        (opencode.json in project)         — project-specific settings
.opencode directories (agents, commands, plugins)
Inline config         (OPENCODE_CONFIG_CONTENT env var)  — runtime overrides
```

To use these configurations, create a symlink at the desired location.
