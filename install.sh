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

# log output syntax presetting
msg=""
tred=$(tput setaf 1)
tgreen=$(tput setaf 2)
tyellow=$(tput setaf 3)
treset=$(tput sgr0)

function log() {
    local level=${1}
    local _msg=""
    if [ $# -gt 2 ]; then
        _msg=${2}
    else
        _msg=${msg}
    fi

    if [ "${level}" == "DEBUG" ]; then
        if ${DEBUG}; then
            echo "(DEBUG)   ${_msg}"
        fi
    elif [ "${level}" == "INFO" ]; then
        echo "${tgreen}(INFO)${treset}    $_msg"
    elif [ "${level}" == "WARNING" ]; then
        echo "${tyellow}(WARNING)${treset} ${_msg}"
    elif [ "${level}" == "ERROR" ]; then
        echo "${tred}(ERROR)${treset}   ${_msg}"
    fi
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

msg="make link .bashrc -> platform specific file"
log INFO

set +e
case "${OS}" in
    "ubuntu")
        ln -snvf bashrc.ubuntu .bashrc ;;
    "centos")
        ln -snvf bashrc.centos .bashrc ;;
    "mac")
        ln -snvf bashrc.mac .bashrc ;;
    *) ;;
esac
set -e

msg="Install dotfiles..."
log INFO

for f in .??*; do
    [ "${f}" = ".git" ] && continue
    [ "${f}" = ".gitignore" ] && continue
    [ "${f}" = ".gitconfig.local.template" ] && continue
    [ "${f}" = ".gitmodules" ] && continue
    [ "${f}" = ".tmux.conf" ] && ! type "tmux" > /dev/null 2>&1 &&\
        msg="Skipping .tmux.conf, tmux is not installed." &&\
        log INFO &&\
        continue
    [ "${f}" = ".config" ] && ! type "nvim" > /dev/null 2>&1 &&\
        msg="Skipping .config, nvim is not installd." &&\
        log INFO &&\
        continue

    LN_NAME="${f}"
    if [ "${f}" = ".bashrc" ]; then
        case "${OS}" in
            "ubuntu") LN_NAME=".bash_aliases" ;;
            "centos") ;;
            "mac") ;;
            *) msg="Skipping .bashrc, your platform is not suppoted."
               log WARNING
               continue;;
        esac
    fi

    if ${TEST_MODE}; then
        msg="(test mode) ln ${LN_OPT} ${SCR_DIR}/${f} ~/${LN_NAME}"
        log INFO
    else
        set +e
        ln ${LN_OPT} ${SCR_DIR}/${f} ~/${LN_NAME}
        set -e
    fi
done

if [ ! -e ~/.config ]; then
    if ${TEST_MODE}; then
        msg="(test mode) mkdir ~/.config"
        log INFO
    else
        msg="mkdir ~/.config"
        log INFO
        mkdir ~/.config
    fi
fi
if ${TEST_MODE}; then
    msg="(test mode) ln ${LN_OPT} ${SCR_DIR}/${f} ~/${LN_NAME}"
    log INFO
else
    set +e
    ln ${LN_OPT} ${SCR_DIR}/.vim ~/.config/nvim
    set -e
fi

msg="Completed!"
log INFO
