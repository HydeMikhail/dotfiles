#! /bin/bash

# Neovim
if [ -d "$HOME/Documents/sources/neovim" ]; then
    echo "Neovim source already on disk"
else
    echo "Cloning neovim repository"
    git clone git@github.com:neovim/neovim.git $HOME/Documents/sources/neovim
fi

# Zoxide
if [ -d "$HOME/Documents/sources/zoxide" ]; then
    echo "Zoxide source already on disk"
else
    echo "Cloning zoxide repository"
    git clone git@github.com:ajeetdsouza/zoxide.git $HOME/Documents/sources/zoxide
    CURR_DIR=$(pwd)
    cd $HOME/Documents/sources/zoxide
    ./install.sh
    cd $CURR_DIR
fi
