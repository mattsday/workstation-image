#!/bin/sh

# Change the shell to zsh
chsh -s /bin/sh user

# Clone & init the shell config if it doesn't exist
if [ ! -d "${HOME}/.dotfiles" ]; then
    sudo -u user git clone https://github.com/mattsday/dotfiles "${HOME}/.dotfiles" && sudo -u user "${HOME}/.dotfiles/init.sh"
fi
