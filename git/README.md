# Git configuration

By default git looks for multiple configuration files starting and prioritises configurations closest to the source. Meaning any conflicting configurations would be resolved by choosing the one closest to the repository. 

1. System - Lowest priority
    - `/etc/gitconfig`

2. User - Medium priority
    - `$HOME/.gitconfig`
    - Git can be told to look for this file elsewhere by setting the `GIT_CONFIG_GLOBAL` environment variable:
        `export GIT_CONFIG_GLOBAL="${HOME}/.config/git/gitconfig"`

3. Repository - Highest priority
    - `<path_to_repository>/.git/config`

