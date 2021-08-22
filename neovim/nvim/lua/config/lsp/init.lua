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
  on_attach = default_on_attach,
  flags = {
    debounce_text_changes = DEBOUNCE,
  },
}

local nls_sources = {}

for lang, config in pairs(language_configs) do
  -- Collect null-ls sources
  nls_sources = vim.list_extend(nls_sources, config.nls_sources)

  -- Set up language server
  if config.ls ~= nil then
    local cfg = vim.tbl_deep_extend("force", default_lsp_config, config.ls.config)
    if not (cfg and cfg.cmd and vim.fn.executable(cfg.cmd[1]) == 1) then
      log.error(lang .. ": cmd not found: " .. vim.inspect(cfg.cmd))
    else
      lspconfig[config.ls.name].setup(cfg)
    end
  end
end

-- Configure null-ls so it's available on lspconfig. Should receive a
-- config table.
nls.config({
  debounce = DEBOUNCE,
  sources = nls_sources,
})

lspconfig["null-ls"].setup({})
