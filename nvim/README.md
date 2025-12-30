# Usage 
You could also create/override the "$XDG_CONFIG_HOME" environment variable.

## Windows

### Command Prompt
```
mklink /D "$HOME\AppData\Local\nvim\" "<path_to_config_dir>"
```

### Powershell
```
New-Item -ItemType SymbolicLink -Path "$HOME\AppData\Local\nvim\" -Target "<path_to_config_dir>
```


## Linux 
```
ln -s "$XDG_CONFIG_HOME/nvim" "<path_to_config_dir>"
```

# Usefull

## 0. Motion reminder or model
```
[<num>]<operator>(<textobject>|<num><motion>)
```

## 1. Ex commands
### 1.1 Healthcheck
```
:checkhealth
```

### 1.2 Global
```
:global/<pattern>/<operator>
```

### 1.2. Close all buffers
```
:%bd
```

### 1.3. Update packages
```
:Lazy! sync
```


## 2. Lua commands
### 2.1 Lsp Log
```
:lua vim.lsp.set_log_level(“off”)
```

## 3. Shell commands
### 3.1 Open terminal
```
!terminal
```

