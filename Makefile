all: neovim

neovim:
	mkdir -p ~/.config/nvim
	cp -r nvim/* ~/.config/nvim/
