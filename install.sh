#!/bin/bash

set -Ceu

function usage() {
    cat << EOT
Usage:
    $0 [OPTIONS]

Options:
    -t  test mode. just output commands but do not make links
    -f  remove existing files (default is interctive)
    -h  show this message
EOT

    exit 1
}

function get_os() {
    if [ "$(uname)" == "Darwin" ]; then
        OS="mac"
    elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
        if [ -e /etc/debian_version ] || [ -e /etc/debian_release ]
        then
            if [ -e /etc/lsb-release ]; then
                OS="ubuntu"
            else
                OS="debian"
            fi
        elif [ -e /etc/redhat-release ]; then
            if [ -e /etc/centos-release ]; then
                OS="centos"
            elif [ -e /etc/oracle-release ]; then
                OS="oracle"
            else
                OS="redhat"
            fi
        else
            OS="linux"
        fi
    else
        echo "Your platform ($(uname -a)) is no supported."
        exit 1
    fi
}

function get_script_dir() {
    if [ -L $0 ]; then
        echo "Please run physical file (not link)."
        exit 1
    fi
    readonly SCR_DIR=$(cd $(dirname $0) && pwd)
}

OS=""
TEST_MODE="false"
LN_OPT="-snvi"

get_os
get_script_dir

cd ${SCR_DIR}

while getopts tfh OPT
do
    case ${OPT} in
        t) TEST_MODE=true ;;
        f) LN_OPT=${LN_OPT/i/}; LN_OPT+='f' ;;
        h) usage ;;
        \?) usage ;;
    esac
done

echo "Install dotfiles..."
for f in .??*; do
    [ "${f}" = ".git" ] && continue
    [ "${f}" = ".gitignore" ] && continue
    [ "${f}" = ".gitconfig.local.template" ] && continue
    [ "${f}" = ".gitmodules" ] && continue
    [ "${f}" = ".tmux.conf" ] && ! type "tmux" > /dev/null 2>&1 &&\
        echo Skipping .tmux.conf, tmux is not installed. && continue

    LN_NAME="${f}"
    if [ "${f}" = ".bashrc" ]; then
        case "${OS}" in
            "ubuntu") LN_NAME=".bashrc_alias";;
            "centos") ;;
            "mac") ;;
            *) echo Skipping .bashrc, your platform is not suppoted. &&\
                continue;;
        esac
    fi

    if ${TEST_MODE}; then
        echo "(test mode) ln ${LN_OPT} ${SCR_DIR}/${f} ~/${LN_NAME}"
    else
        set +e
        ln ${LN_OPT} ${SCR_DIR}/${f} ~/${LN_NAME}
        set -e
    fi
done

echo "Completed!"

