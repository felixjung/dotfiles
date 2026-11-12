# Run from this directory (or make -C dot_config/rex). No preferences or reloads.
STYLUA := $(if $(wildcard /opt/homebrew/bin/stylua),/opt/homebrew/bin/stylua,stylua)
SELENE := $(if $(wildcard /opt/homebrew/bin/selene),/opt/homebrew/bin/selene,selene)
LUAJIT := $(if $(wildcard /opt/homebrew/bin/luajit),/opt/homebrew/bin/luajit,luajit)
REX := $(HOME)/Library/Application Support/com.superlogical.rex/RexServer/Versions/Current/Rex Server.app/Contents/MacOS/rex
PROFILES := . viewer
LUA_FILES := init.lua keys.lua scrollback.lua lazygit.lua scratch.lua tests/test_scratch.lua viewer/init.lua types/rex.lua

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
check: format-check lint test runtime-check
