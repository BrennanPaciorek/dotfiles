all: neovim-config git-config

neovim-config:
	mkdir -p "${HOME}/.config/nvim/lua"
	cp "neovim/init.lua" "${HOME}/.config/nvim/init.lua"
	rsync -a --delete "neovim/lua/" "${HOME}/.config/nvim/lua/"

git-config:
	mkdir -p "${HOME}/.config/"
	rm -rf "${HOME}/.config/git-template"
	cp -r git/git-template/ "${HOME}/.config/git-template"
	git config --global init.templateDir "${HOME}/.config/git-template"
