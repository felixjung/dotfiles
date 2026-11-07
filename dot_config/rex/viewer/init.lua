local function initialize()
  -- This file runs only in the disposable, configuration-free Neovim process.
  vim.o.modeline = false
  vim.o.shada = ""
  vim.o.clipboard = ""
  vim.o.writebackup = false
  vim.o.backup = false
  vim.o.undofile = false
  vim.bo.swapfile = false
  local path = assert(vim.env.REX_SNAPSHOT, "Snapshot path missing")
  local file = assert(io.open(path, "rb"), "Cannot open snapshot")
  local text = file:read("*a")
  file:close()
  assert(text, "Cannot read snapshot")
  assert(os.remove(path), "Cannot unlink snapshot")
  local lines = vim.split(text, "\n", { plain = true })
  local final_newline = text:sub(-1) == "\n"
  if final_newline then
    table.remove(lines)
  end
  if #lines == 0 then
    lines = { "" }
  end
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  text = nil
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
  vim.bo.filetype = ""
  vim.bo.endofline = final_newline
  vim.bo.readonly = true
  vim.bo.modifiable = false
  vim.bo.modified = false
  vim.api.nvim_buf_set_name(0, "Terminal scrollback snapshot")
  vim.o.number = true
  vim.o.wrap = false
  vim.api.nvim_win_set_cursor(0, { #lines, 0 })
  local function copy()
    local selection = vim.fn.getreg('"')
    local ok = pcall(vim.system, { "/usr/bin/pbcopy" }, { stdin = selection }, function(result)
      if result.code ~= 0 then
        vim.schedule(function()
          vim.notify("Clipboard copy failed (pbcopy)", vim.log.levels.ERROR)
        end)
      end
    end)
    if not ok then
      vim.notify("Clipboard copy failed (pbcopy could not start)", vim.log.levels.ERROR)
    end
  end
  vim.keymap.set("n", "yy", function()
    vim.cmd("normal! yy")
    copy()
  end, { buffer = true })
  vim.keymap.set("x", "y", function()
    vim.cmd("normal! y")
    copy()
  end, { buffer = true })
  vim.keymap.set({ "n", "x" }, "q", "<Cmd>qa!<CR>", { buffer = true })
end
local ok = pcall(initialize)
if not ok then
  -- Never log the snapshot or arbitrary filesystem error text.
  if vim.env.REX_SNAPSHOT then
    os.remove(vim.env.REX_SNAPSHOT)
  end
  vim.notify("Cannot load isolated scrollback snapshot", vim.log.levels.ERROR)
  vim.cmd("cquit 1")
end
