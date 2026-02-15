# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/go/bin:$HOME/bin/calibre:" ]]
then
    PATH="$HOME/go/bin:$HOME/bin/calibre:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc

set -o vi

alias vi="nvim"
alias vip="nvim --clean -n -i NONE -c 'set nobackup nowritebackup noundofile nomodeline noexrc clipboard= noshelltemp secure'"
alias task="nvim -c 'lua require(\"orgmode\").action(\"capture.prompt\")'"
alias agenda="nvim -c 'lua require(\"orgmode\").action(\"agenda.prompt\")'"

HISTSIZE=100000 # Number of entries kept in memory
HISTFILESIZE=100000 # Number of entries kept in the file
HISTTIMEFORMAT='%F %T ' # Entries will be stored according to a pattern, in this case with date and time
HISTCONTROL=ignoreboth # Don't store duplicates and entries starting with a space

FZF_DEFAULT_OPTS="--preview 'bat --color=always {}'"
