all: neovim git-config

neovim:
	mkdir -p "${HOME}/.config/nvim"
	cp -r nvim/* "${HOME}/.config/nvim/"

git-config:
	mkdir -p "${HOME}/.config/"
	rm -rf "${HOME}/.config/git-template"
	cp -r git/git-template/ "${HOME}/.config/git-template"
	git config --global init.templateDir "${HOME}/.config/git-template"
