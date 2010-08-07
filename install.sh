#!/bin/sh

set -e

echo "Installing... vimrc"
install --mode=644 --backup=t vimrc ~/.vimrc
echo "done."
exit
