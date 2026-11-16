local M = { name = "Rex", protocol_version = "^3.0.0" }

function M.detect()
  return vim.env.REX_SESSION ~= nil and vim.env.REX_SESSION ~= ""
    and vim.env.REX_BLOCK ~= nil and vim.env.REX_BLOCK ~= ""
end

function M.move(direction)
  local argv = {
    vim.env.REX_BIN_PATH or "rex", "--timeout", "1s", "do", "smart_splits_focus",
    "direction=" .. direction, "-s", vim.env.REX_SESSION, "-b", vim.env.REX_BLOCK, "--json",
  }
  local ok, result = pcall(function()
    return vim.system(argv, { text = true, timeout = 1500 }):wait()
  end)
  if not ok or result.code ~= 0 then
    vim.schedule(function()
      vim.notify_once("Rex navigation failed; check the server configuration and Rex CLI on PATH", vim.log.levels.WARN)
    end)
  end
  -- Even failed/stale requests consume the boundary movement: returning false
  -- would let smart-splits wrap around inside the editor.
  return true
end

return M
