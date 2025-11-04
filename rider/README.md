# Usage

Create a symlink from $HOME/.ideavimrc 

## Windows 

### Command Prompt
```
mklink "$HOME\.ideavimrc" "<path_to_actual_config>"
```

### Powershell
```
New-Item -ItemType SymbolicLink -Path "$HOME\.ideavimrc" -Target "<path_to_actual_config>"
```

## Linux
```
ln -s "$HOME/.ideavimrc <path_to_actual_config>
```

