.PHONY: common laptop
common:
	stow bash
	stow cheat
	stow nvim
	stow tmux
	stow vim
laptop: common
	stow dotdesktop
	stop dotlocal
	stow recoll
	stow fonts
