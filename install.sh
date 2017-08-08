#!/bin/bash

set -Ceu

SCR_DIR=$(dirname $(readlink -f $0))

cd $SCR_DIR

echo "isntall dotfiles..."
for f in .??*; do
    [ "f" = ".git"] && continue
    [ "f" = ".gitconfig.local.template" ] && continue
    [ "f" = ".gitmodules"] && continue

    echo "install "f"\n."
    ln -snfv ~/dotfile/"$f" ~/
done

echo "completed!\n"

