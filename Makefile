MAKE_DIR := $(CURDIR)
SHELL := /bin/bash

create-shortcut:
	@chmod +x dotfiles.sh; \
	RC_FILE=$$(bash -c ' \
		if echo "$$SHELL" | grep -q zsh; then \
			echo "$$HOME/.zshrc"; \
		else \
			echo "$$HOME/.bashrc"; \
		fi'); \
	\
	if grep -qxF "alias dotfiles='$(MAKE_DIR)/dotfiles.sh'" "$$RC_FILE" 2>/dev/null; then \
		echo "Alias already exists in $$RC_FILE — skipping"; \
	else \
		echo "alias dotfiles='$(MAKE_DIR)/dotfiles.sh'" >> "$$RC_FILE"; \
		echo "Alias added to $$RC_FILE"; \
		echo "Run: source $$RC_FILE (or restart your shell)"; \
	fi

1 s sync 1sync sync1:
	bash dotfiles.sh sync

2 g sync 1sync sync1:
	bash dotfiles.sh git


test:
	sh ./tests/test_no_duplication.sh

get-wezterm:
	cp ./sync/.wezterm.lua ~/.wezterm.lua

get-bashrc:
	cp ./sync/.bashrc ~/.bashrc