# Alacritty configuratio

By default alacritty looks for configuration files in a few locations depending on the environment. If one is not found, it will use the default configuration file baked into the product. It uses the first file it finds.

## Unix
In search order (I think):

    $XDG_CONFIG_HOME/alacritty/alacritty.toml

    $XDG_CONFIG_HOME/alacritty.toml

    $HOME/.config/alacritty/alacritty.toml

    $HOME/.alacritty.toml

    /etc/alacritty/alacritty.toml

## Windows
    %APPDATA%\alacritty\alacritty.toml

