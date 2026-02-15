# Usage

## Windows

### Command Prompt
```
mklink /D LINK_NAME TARGET
```

### Powershell
```
New-Item -ItemType SymbolicLink -Path LINK_NAME -Target TARGET
```

## Linux 
```
ln -s TARGET LINK_NAME
```

- `TARGET`: The actual file or directory you want to link to
- `LINK_NAME`: The path where you want to create the symlink
