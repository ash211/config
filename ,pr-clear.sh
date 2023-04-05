#!/bin/sh
# 
# Deletes git branches in the current repo if they've already been merged upstream

git fetch --all -p; git branch -vv | grep ": gone]" | awk '{ print $1 }' | xargs -n 1 git branch -D
