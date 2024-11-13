#!/bin/sh

# Where is the user's home?
USER_HOME="/home/user"

# Change the shell to zsh
chsh -s /bin/sh user

# Clone & init the shell config if it doesn't exist
if [ ! -d "${USER_HOME}/.dotfiles" ]; then
    sudo -u user git clone https://github.com/mattsday/dotfiles "${USER_HOME}/.dotfiles" && sudo -u user "${USER_HOME}/.dotfiles/init.sh"
fi
