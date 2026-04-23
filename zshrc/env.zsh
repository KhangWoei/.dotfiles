# XDG
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export XDG_CONFIG_HOME="$HOME/.config"

# Editor
export EDITOR="nvim"
export VISUAL="$EDITOR"

# Path
export PATH="${HOME}/.bin:$PATH"

# Git
export GIT_CONFIG_GLOBAL="$XDG_CONFIG_HOME/.gitconfig"

# SSH
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
