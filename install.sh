#!/bin/bash

set -Ceu

SCR_DIR=$(dirname $(readlink -f $0))

cd $SCR_DIR

echo "Isntall dotfiles..."
for f in .??*; do
    [ "$f" = ".git" ] && continue
    [ "$f" = ".gitignore" ] && continue
    [ "$f" = ".gitconfig.local.template" ] && continue
    [ "$f" = ".gitmodules" ] && continue

    ln -snfv $SCR_DIR/$f ~/
done

echo "completed!"

