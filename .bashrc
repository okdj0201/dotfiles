# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
alias ll='ls -l'
alias la='ls -la'
alias ap='ansible-playbook'

if type "nvim" > /dev/null 2>&1
then
    alias vim='nvim'
fi


