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

