local lspconfig = require("lspconfig")
local log = require("lib.log")
local nls = require("null-ls")

local mapping = require("lib.keymapping")
local language_configs = require("config.lsp.langs")

-- TODO: what does this do?
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { "documentation", "detail", "additionalTextEdits" },
}

local DEBOUNCE = 150

local function default_on_attach(_, bufnr)
  -- Goto...
  mapping.nnoremap("gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { buffer = bufnr })
  mapping.nnoremap("gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { buffer = bufnr })
  -- Other stuff.
  mapping.nnoremap("K", "<cmd>lua vim.lsp.buf.hover()<CR>", { buffer = bufnr })
end

local default_lsp_config = {
  flags = {
    debounce_text_changes = DEBOUNCE,
  },
}

local function new_on_attach(on_attach)
  return function(client, bufnr)
    default_on_attach(client, bufnr)

    if type(on_attach) == "function" then
      on_attach(client, bufnr)
    end

    -- Register formatting on save
    if client.resolved_capabilities.document_formatting then
      vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
    end
  end
end

local nls_sources = {}

-- Collect null-ls sources
for _, config in pairs(language_configs) do
  nls_sources = vim.list_extend(nls_sources, config.nls_sources)
end

-- Configure null-ls so it's available on lspconfig. Should receive a
-- config table.
nls.config({
  debounce = DEBOUNCE,
  sources = nls_sources,
})

-- null-ls is set up last and handles multiple languages and features.
-- Configure it centrally.
lspconfig["null-ls"].setup({
  on_attach = new_on_attach(),
})

-- Collect null-ls sources
for lang, config in pairs(language_configs) do
  -- Set up language server
  if config.ls ~= nil then
    local cfg = vim.tbl_deep_extend(
      "force",
      default_lsp_config,
      config.ls.config,
      { on_attach = new_on_attach(config.ls.config.on_attach) }
    )

    if not (cfg and cfg.cmd and vim.fn.executable(cfg.cmd[1]) == 1) then
      log.error(lang .. ": cmd not found: " .. vim.inspect(cfg.cmd))
    else
      lspconfig[config.ls.name].setup(cfg)
    end
  end
end
