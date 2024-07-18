#! /bin/bash

# Neovim
if [ -d "$HOME/Documents/sources/neovim" ]; then
    echo "Neovim source already on disk"
else
    echo "Cloning neovim repository"
    git clone git@github.com:neovim/neovim.git $HOME/Documents/sources/neovim
fi

<<<<<<< HEAD
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
=======
# ZOxide
if [ -d "$HOME/Documents/sources/zoxide" ]; then
    echo "zoxide source already on disk"
else
    echo "Cloning zoxide repository"
    git clone git@github.com:ajeetdsouza/zoxide.git $HOME/Documents/sources/zoxide
>>>>>>> 0637a59b8903251429fa65cad1e1fe6e74eea602
fi
