local lspconfig = require'lspconfig'

local function hover_wrap(_, method, result)
    vim.lsp.util.focusable_float(method, function()
        if not (result and result.contents) then
            -- return { 'No information available' }
            return
        end
        local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
        markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)
        if vim.tbl_isempty(markdown_lines) then
            -- return { 'No information available' }
            return
        end
        local bufnr, winnr = vim.lsp.util.fancy_floating_markdown(markdown_lines)
        vim.lsp.util.close_preview_autocmd({"CursorMoved", "BufHidden", "InsertCharPre"}, winnr)
        local hover_len = #vim.api.nvim_buf_get_lines(bufnr,0,-1,false)[1]
        local win_width = vim.api.nvim_win_get_width(0)
        if hover_len > win_width then
            vim.api.nvim_win_set_width(winnr,math.min(hover_len,win_width))
            vim.api.nvim_win_set_height(winnr,math.ceil(hover_len/win_width))
            vim.wo[winnr].wrap = true
        end
        return bufnr, winnr
    end)
end

vim.lsp.callbacks['textDocument/hover'] = hover_wrap

require'lspconfig'.gopls.setup{
  cmd = { "gopls" },
  filetypes = { "go", "gomod" },
  root_dir = lspconfig.util.root_pattern("go.mod", ".git"),
  on_attach = require'completion'.on_attach,
}

require'lspconfig'.tsserver.setup{
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json"),
  on_attach = require'completion'.on_attach,
}

require'lspconfig'.dockerls.setup{
  on_attach = require'completion'.on_attach,
}

require'lspconfig'.jsonls.setup{
  settings = {
    json = {
      format = {
        enable = false,
      },
    },
  },
  on_attach = require'completion'.on_attach,
}
