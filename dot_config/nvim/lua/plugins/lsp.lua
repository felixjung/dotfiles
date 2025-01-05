local conform_util = require("conform.util")
local util = require("lspconfig.util")

local function file_exists(files)
	return function(ctx)
		return vim.fs.find(
			files,
			{ path = ctx.filename, type = "file", upward = true }
		)[1]
	end
end

return {
	-- tools
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			automatic_installation = { exclude = { "gopls" } },
		},
	},
	{
		"folke/neoconf.nvim",
		cmd = "Neoconf",
		config = {
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
				tsserver = {
					root_dir = util.root_pattern("tsconfig.json"),
				},
				denols = {
					root_dir = util.root_pattern("deno.json", "deno.jsonc"),
				},
				eslint = {
					root_dir = util.root_pattern(".eslintrc.json", ".eslintrc.js"),
				},
				biome = {
					root_dir = util.root_pattern("biome.json"),
					filetypes = {
						"javascript",
						"javascriptreact",
						"typescript",
						"typescript.tsx",
						"typescriptreact",
					},
				},
				html = {},
				gopls = {
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
							completeUnimported = true,
							allowModfileModifications = true,
							enhancedHover = true,
							deepCompletion = true,
							workspaceConfiguration = true,
							expandWorkspaceToModule = true,
							semanticTokens = true,
							semanticTokensAutoEnabled = true,
							semanticTokensRefresh = "on",
							["local"] = "github.com/sumup",
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
				lua_ls = {},
				vimls = {},
			},
		},
	},

	-- Linters and formatters.

	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				["markdown"] = { "dprint", "markdownlint-cli2", "markdown-toc" },
				["markdown.mdx"] = { "dprint", "markdownlint-cli2", "markdown-toc" },

				["javascript"] = { "biome", "prettierd", "prettier" },
				["javascriptreact"] = { "biome", "prettierd", "prettier" },
				["typescript"] = { "biome", "prettierd", "prettier" },
				["typescriptreact"] = { "biome", "prettierd", "prettier" },

				-- ["yaml"] = { "prettierd", "prettier" },

				-- ["go"] = { "goimports" },

				["terraform"] = { "terraform_fmt" },
			},
			formatters = {
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
				["markdownlint-cli2"] = {
					condition = function(_, ctx)
						local diag = vim.tbl_filter(function(d)
							return d.source == "markdownlint"
						end, vim.diagnostic.get(ctx.buf))
						return #diag > 0
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
				dprint = {
					condition = file_exists({
						"dprint.json",
						"dprint.jsonc",
						".dprint.json",
						".dprint.jsonc",
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
				markdown = { "markdownlint-cli2" },
				fish = { "fish" },
				go = { "golangcilint" },
				bash = { "shellcheck" },
			},
			linters = {
				selene = {
					condition = function(ctx)
						local root = LazyVim.root.get({ normalize = true })
						if root ~= vim.uv.cwd() then
							return false
						end
						return vim.fs.find(
							{ "selene.toml" },
							{ path = root, upward = true }
						)[1]
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
