# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

export EDITOR="/usr/bin/vim"


#export PS1="[\u@\h \W]\$ "
_GREEN=$(tput setaf 2)
_BLUE=$(tput setaf 4)
_RED=$(tput setaf 1)
_WHITE=$(tput setaf 7)
_CYAN=$(tput setaf 6)
_RESET=$(tput sgr0)
_BOLD=$(tput bold)
export PS1="${_RED}${_BOLD}[\u@\h \W]\$ ${_RESET}"







# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
