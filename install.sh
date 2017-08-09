#!/bin/bash

set -Ceu

readonly SCR_DIR=$(dirname $(readlink -f $0))
TEST_MODE=false
LN_OPT="-snvi"

cd $SCR_DIR

function usage() {
    cat << EOT
 Usage:
    $0 [OPTIONS]

Options:
    -t  test mode. just output commands but do not make links
    -f  remove existing files. default is interctive.
    -h  show this message

EOT

    exit 1
}

while getopts tfih OPT
do
    case $OPT in
        t) TEST_MODE=true
            ;;
        f) LN_OPT+='f'
            ;;
        h) usage
            ;;
        \?) usage
            ;;
    esac
done

echo "Isntall dotfiles..."
for f in .??*; do
    [ "$f" = ".git" ] && continue
    [ "$f" = ".gitignore" ] && continue
    [ "$f" = ".gitconfig.local.template" ] && continue
    [ "$f" = ".gitmodules" ] && continue

    if $TEST_MODE; then
        echo "ln $LN_OPT $SCR_DIR/$f ~/$f"
    else
        ln $LN_OPT $SCR_DIR/$f ~/
    fi
done

echo "completed!"

