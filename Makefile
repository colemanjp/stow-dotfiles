.PHONY: common laptop
common:
	stow bash
	stow nvim
	stow tmux
	stow vim
laptop: common
	stow devilspie2
	stow dotdesktop
	stow recoll
