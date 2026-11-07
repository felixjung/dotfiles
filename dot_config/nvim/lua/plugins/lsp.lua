-- Project tools follow the buffer, not the outer chezmoi git root or cwd.
local function buffer_config(filename, files)
	return vim.fs.find(files, { path = vim.fs.dirname(filename), type = "file", upward = true })[1]
end

local function brew_tool(name)
	local path = "/opt/homebrew/bin/" .. name
	return vim.fn.executable(path) == 1 and path or name
end

local function file_exists(files)
	return function(ctx)
		return vim.fs.find(
			files,
			{ path = ctx.filename, type = "file", upward = true }
		)[1]
	end
end

return {
	-- Explicit LuaLS profiles own their host libraries; do not inject Neovim.
	{
		"folke/lazydev.nvim",
		opts = {
			enabled = function(root)
				if vim.fs.find({ ".luarc.json", ".luarc.jsonc" }, { path = root, upward = true })[1] then
					return false
				end
				return vim.g.lazydev_enabled ~= false
			end,
		},
	},
	-- tools
	{
		"folke/neoconf.nvim",
		cmd = "Neoconf",
		opts = {
			import = {
				vscode = false,
				coc = false,
				nlsp = false,
			},
		},
		dependencies = { "nvim-lspconfig" },
	},

	-- lsp servers
	{
		"neovim/nvim-lspconfig",
		opts = {
			diagnostics = {
				underline = false,
			},
			servers = {
				ansiblels = {},
				bashls = {},
				cssls = {},
				dockerls = {},
				typos_lsp = {
					init_options = {
						config = "~/.config/typos/typos.toml",
						diagnosticSeverity = "Warning",
					},
				},
				vtsls = {},
				denols = {},
				eslint = {
					settings = {
						workingDirectories = { mode = "auto" },
					},
				},
				biome = {
					filetypes = {
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
					},
				},
				html = {},
				gopls = {
					mason = false,
					settings = {
						gopls = {
							analyses = {
								unusedparams = true,
								fieldalignment = true,
								nonewvars = true,
								nilness = true,
								shadow = true,
								unusedwrite = true,
								unsafeptr = true,
								unsafetype = true,
							},
							staticcheck = true,
							linksInHover = false,
							usePlaceholders = true,
							usePlaceholdersForGoArguments = true,
							usePlaceholdersForFunctionCalls = true,
							allowModfileModifications = true,
							enhancedHover = true,
							deepCompletion = true,
							workspaceConfiguration = true,
							expandWorkspaceToModule = true,
							semanticTokens = true,
							semanticTokensAutoEnabled = true,
							semanticTokensRefresh = "on",
							-- NOTE: using goimports from here isn't as configurable as when
							-- used locally.
							-- ["local"] = "github.com/sumup",
						},
					},
				},
				terraformls = {},
				rust_analyzer = {
					settings = {
						["rust-analyzer"] = {
							cargo = { allFeatures = true },
							checkOnSave = {
								command = "clippy",
								extraArgs = { "--no-deps" },
							},
						},
					},
				},
				yamlls = {
					settings = {
						yaml = {
							redhat = { telemetry = { enabled = false } },
							format = {
								enable = true,
								singleQuote = false,
								bracketSpacing = false,
								prosewrap = "always",
								printWidth = 80,
							},
							validate = true,
							completion = true,
							schemaStore = {
								url = "https://www.schemastore.org/api/json/catalog.json",
								enable = true,
							},
							schemas = {
								["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
								["https://json.schemastore.org/prettierrc"] = ".prettierrc",
								["https://json.schemastore.org/tsconfig"] = "tsconfig*.json",
								["https://json.schemastore.org/vscode"] = ".vscode/settings.json",
							},
						},
					},
				},
				jsonnet_ls = {
					cmd = { "jsonnet-language-server", "-t" },
					settings = {
						formatting = {
							-- default values
							Indent = 2,
							MaxBlankLines = 2,
							StringStyle = "single",
							CommentStyle = "slash",
							PrettyFieldNames = true,
							PadArrays = false,
							PadObjects = true,
							SortImports = false,
							UseImplicitPlus = true,
							StripEverything = false,
							StripComments = false,
							StripAllButComments = false,
						},
					},
				},
				lua_ls = {
					cmd = { brew_tool("lua-language-server") },
					root_dir = function(bufnr, on_dir)
						local filename = vim.api.nvim_buf_get_name(bufnr)
						local config = buffer_config(filename, { ".luarc.json", ".luarc.jsonc" })
						local root = config and vim.fs.dirname(config)
							or vim.fs.root(bufnr, vim.lsp.config.lua_ls.root_markers)
						on_dir(root)
					end,
				},
				vimls = {},
			},
		},
	},

	-- Linters and formatters.

	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				["lua"] = { "stylua" },
				["markdown"] = { "rumdl", "markdown-toc" },
				["markdown.mdx"] = { "rumdl", "markdown-toc" },

				["javascript"] = { "biome", "prettierd", "prettier" },
				["javascriptreact"] = { "biome", "prettierd", "prettier" },
				["typescript"] = { "biome", "prettierd", "prettier" },
				["typescriptreact"] = { "biome", "prettierd", "prettier" },

				-- ["yaml"] = { "prettierd", "prettier" },

				["go"] = { "goimports" },

				["terraform"] = { "terraform_fmt" },
			},
			formatters = {
				stylua = {
					command = brew_tool("stylua"),
					condition = function(_, ctx)
						return buffer_config(ctx.filename, { ".stylua.toml", "stylua.toml" }) ~= nil
					end,
					cwd = function(_, ctx)
						local config = buffer_config(ctx.filename, { ".stylua.toml", "stylua.toml" })
						return config and vim.fs.dirname(config)
					end,
					require_cwd = true,
				},
				["markdown-toc"] = {
					condition = function(_, ctx)
						for _, line in
							ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false))
						do
							if line:find("<!%-%- toc %-%->") then
								return true
							end
						end
					end,
				},
				prettierd = {
					condition = file_exists({
						".prettierrc",
						".prettierrc.js",
						"prettier.config.js",
						".prettierrc.json",
					}),
				},
				prettier = {
					condition = file_exists({
						".prettierrc",
						".prettierrc.js",
						"prettier.config.js",
						".prettierrc.json",
					}),
				},
			},
		},
	},
	{
		"mfussenegger/nvim-lint",
		opts = {
			events = { "BufWritePost", "BufReadPost", "InsertLeave" },
			linters_by_ft = {
				lua = { "selene" },
				markdown = { "rumdl" },
				fish = { "fish" },
				go = { "golangcilint" },
				bash = { "shellcheck" },
			},
			linters = {
				selene = {
					cmd = brew_tool("selene"),
					condition = function(ctx)
						local config = buffer_config(ctx.filename, { "selene.toml" })
						if not config then
							return false
						end
						-- nvim-lint expects a string cwd; LazyVim calls this before try_lint.
						require("lint").linters.selene.cwd = vim.fs.dirname(config)
						return true
					end,
				},
				luacheck = {
					condition = function(ctx)
						local root = LazyVim.root.get({ normalize = true })
						if root ~= vim.uv.cwd() then
							return false
						end
						return vim.fs.find(
							{ ".luacheckrc" },
							{ path = root, upward = true }
						)[1]
					end,
				},
			},
		},
	},
}
