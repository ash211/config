#!/bin/sh

set -e

echo "Installing... ~/.vimrc"
if [ ! -f ~/.vimrc ]; then
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
if [ ! -f ~/.bash_aliases ]; then
    ln -s `pwd`/bash_aliases ~/.bash_aliases
else
    echo "~/.bash_aliases already exists... preserving."
fi

echo "done."
exit
