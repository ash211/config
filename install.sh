#!/bin/sh

set -e

if ( [ ! -f ~/.vimrc ] || ( [ -f ~/.vimrc ] && [ ! -f ~/.vimrc.old ] ) )
then
    if [ -f ~/.vimrc ]
    then
        echo "Backing up ~/.vimrc to ~/.vimrc.old"
        mv ~/.vimrc ~/.vimrc.old
    fi
    echo "Installing new .vimrc"
    cp vimrc ~/.vimrc
else
    if [ -f ~/.vimrc.old ]
    then
        echo "Not updating .vimrc ... detected ~/.vimrc.old"
    fi
fi
