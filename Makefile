all: neovim git-config

neovim:
	mkdir -p ~/.config/nvim
	cp -r nvim/* ~/.config/nvim/

git-config:
	mkdir -p ~/.config/
	rm -rf ~/.config/git-template
	cp -r git/git-template/ ~/.config/git-template
	git config --global init.templateDir ~/.config/git-template
