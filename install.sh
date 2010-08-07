#!/bin/sh

set -e

echo "Installing... ~/.vimrc"
install --mode=644 --backup=t -D vimrc ~/.vimrc

echo "Installing... ~/.vim/"
pushd vim
find . -type f -exec install -D {} ~/.vim/{} \;
popd

echo "done."
exit
