# Opencode configuration

Like git, opencode configuration are merged togehter following the given precedence order:  

```
    Remote config (from .well-known/opencode) - organizational defaults
    Global config (~/.config/opencode/opencode.json) - user preferences
    Custom config (OPENCODE_CONFIG env var) - custom overrides
    Project config (opencode.json in project) - project-specific settings
    .opencode directories - agents, commands, plugins
    Inline config (OPENCODE_CONFIG_CONTENT env var) - runtime overrides
```

To use these configurations, create a symlink at the desired location.
