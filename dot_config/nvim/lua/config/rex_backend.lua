local M = { name = "Rex", protocol_version = "^3.0.0" }

function M.detect()
  return vim.env.REX_SESSION ~= nil and vim.env.REX_SESSION ~= ""
    and vim.env.REX_BLOCK ~= nil and vim.env.REX_BLOCK ~= ""
end

local function request(action, direction, amount)
  local argv = {
    vim.env.REX_BIN_PATH or "rex", "--timeout", "1s", "do", action,
    "direction=" .. direction,
  }
  if amount then
    argv[#argv + 1] = "amount=" .. amount
  end
  vim.list_extend(argv, { "-s", vim.env.REX_SESSION, "-b", vim.env.REX_BLOCK, "--json" })
  local ok, result = pcall(function()
    return vim.system(argv, { text = true, timeout = 1500 }):wait()
  end)
  if not ok or result.code ~= 0 then
    vim.schedule(function()
      vim.notify_once("Rex pane request failed; check the server configuration and Rex CLI on PATH", vim.log.levels.WARN)
    end)
  end
  -- Even failed/stale requests consume the boundary movement: returning false
  -- would let smart-splits wrap around inside the editor.
  return true
end

function M.move(direction)
  return request("smart_splits_focus", direction)
end

function M.resize(direction, opts)
  return request("smart_splits_resize", direction, (opts and opts.amount) or 3)
end

return M
