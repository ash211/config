#!/bin/sh

set -e

echo "Installing... ~/.vimrc"
if [ ! -e ~/.vimrc ]; then
    ln -s `pwd`/vimrc ~/.vimrc
else
    echo "~/.vimrc already exists... preserving."
fi

echo "Installing... ~/.vim/"
if [ ! -d ~/.vim/ ]; then
    ln -s `pwd`/vim ~/.vim
else
    echo "~/.vim/ already exists... preserving."
fi

echo "Installing... ~/.bash_aliases"
if [ ! -e ~/.bash_aliases ]; then
    ln -s `pwd`/bash_aliases ~/.bash_aliases
else
    echo "~/.bash_aliases already exists... preserving."
fi

echo "Installing... ~/.gitconfig"
if [ ! -e ~/.gitconfig ]; then
    ln -s `pwd`/gitconfig ~/.gitconfig
else
    echo "~/.gitconfig already exists... preserving."
fi

echo "Installing... ~/.tmux.conf"
if [ ! -e ~/.tmux.conf ]; then
    ln -s `pwd`/tmux.conf ~/.tmux.conf
else
    echo "~/.tmux.conf already exists... preserving."
fi

echo "Installing... ~/.zshrc"
if [ ! -e ~/.zshrc ]; then
    ln -s `pwd`/zshrc ~/.zshrc
else
    echo "~/.zshrc already exists... preserving."
fi

echo "done."
exit
