# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin/calibre

export VISUAL="${EDITOR}"

export FREEPLANE_USE_UNSUPPORTED_JAVA_VERSION=1
export FZF_DEFAULT_OPTS="--preview 'bat --color=always {}'"
