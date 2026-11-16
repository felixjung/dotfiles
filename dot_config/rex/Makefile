# Run from this directory (or make -C dot_config/rex). No preferences or reloads.
STYLUA ?= stylua
SELENE ?= selene
LUAJIT ?= luajit
REX ?= rex
NVIM ?= nvim
PROFILES := . viewer
LUA_FILES := init.lua keys.lua scroll.lua scrollback.lua lazygit.lua scratch.lua navigation.lua tests/test_scratch.lua tests/test_scroll.lua tests/test_navigation.lua tests/test_backend.lua tests/test_viewer.lua viewer/init.lua types/rex.lua

.PHONY: format format-check lint test runtime-check check
format:
	$(STYLUA) --config-path .stylua.toml $(LUA_FILES)
format-check:
	$(STYLUA) --check --config-path .stylua.toml $(LUA_FILES)
lint:
	@set -e; for root in $(PROFILES); do (cd "$$root" && $(SELENE) .); done
runtime-check:
	"$(REX)" config check "$(CURDIR)/init.lua" --json
test:
	$(LUAJIT) tests/test_scratch.lua
	$(LUAJIT) tests/test_scroll.lua
	$(LUAJIT) tests/test_navigation.lua
	$(NVIM) --headless --clean -l tests/test_backend.lua
	$(NVIM) --headless --clean -l tests/test_viewer.lua
check: format-check lint test runtime-check
