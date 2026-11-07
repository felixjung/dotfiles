local M = {}
local terminal = "com.superlogical.terminal"
local max_bytes, chunk_bytes, max_chunks = 16 * 1024 * 1024, 48 * 1024, 4096
---@generic T
---@param value T?
---@param message string
---@return T
local function check(value, message)
  if not value then
    error("Scrollback viewer: " .. message, 0)
  end
  return value
end
---@param method string
---@param args table
---@return RexCallResult
local function call(method, args)
  local result = rex.call(method, args)
  -- Do not surface server text: it could contain private terminal data.
  return check(result, method .. " failed")
end
local function integer(n)
  return type(n) == "number" and n >= 0 and n == math.floor(n)
end
---@param ctx RexContext
---@return string
function M.capture(ctx)
  check(ctx.session_id and ctx.block_id, "invoking terminal IDs required")
  local function request(method, args)
    return call(
      terminal .. "." .. method,
      { session_id = ctx.session_id, block_id = ctx.block_id, args = args }
    )
  end
  local first =
    request("format", { format = "text", trim = false, unwrap = false, max_bytes = chunk_bytes })
  check(type(first.content) == "string", "invalid snapshot content")
  local parts, offset, total, id = { first.content }, #first.content, first.total, first.id
  check(offset <= max_bytes, "snapshot exceeds 16 MiB limit")
  if total ~= nil then
    check(
      integer(total) and total >= offset and total <= max_bytes,
      "invalid or oversized snapshot length"
    )
  end
  if id == nil then
    check(first.eof ~= false and (total == nil or total == offset), "incomplete snapshot")
    return first.content
  end
  check(integer(id) and id > 0 and integer(total), "invalid snapshot identity/length")
  check(
    (first.eof == nil or first.eof == false) and offset < total,
    "inconsistent snapshot completion"
  )
  for _ = 1, max_chunks do
    local part = request("blob_read", { id = id, offset = offset, max_bytes = chunk_bytes })
    check(part.id == id and part.total == total, "snapshot identity/length changed")
    check(type(part.data) == "string" and #part.data > 0, "snapshot read made no progress")
    offset = offset + #part.data -- Lua string length is bytes, not UTF-8 characters.
    check(offset <= total and offset <= max_bytes, "snapshot length overflow")
    parts[#parts + 1] = part.data
    check(type(part.eof) == "boolean", "missing snapshot completion marker")
    if part.eof then
      check(offset == total, "incomplete snapshot")
      return table.concat(parts)
    end
    check(offset < total, "missing snapshot completion")
  end
  error("Scrollback viewer: snapshot exceeds chunk limit", 0)
end

-- The shell receives only argv paths, never interpolated data. It owns exactly
-- snapshot and its mktemp directory; no recursive deletion or wildcard cleanup.
local wrapper = [[
umask 077
snapshot=$1/snapshot
trap '/bin/rm -f -- "$snapshot"; /bin/rmdir -- "$1" 2>/dev/null' EXIT
trap 'exit 130' HUP INT TERM
export REX_SNAPSHOT="$snapshot" REX_VIEWER="$2" NVIM_LOG_FILE=/dev/null
unset VIMINIT EXINIT NVIM NVIM_LISTEN_ADDRESS
"$3" --clean -u NONE -i NONE -n --noplugin --cmd 'set nomodeline noswapfile shada= clipboard=' -c 'lua dofile(vim.env.REX_VIEWER)'
]]
---@param dir string
---@param root string
---@return string[]
function M.command(dir, root)
  return {
    "/bin/sh",
    "-c",
    wrapper,
    "rex-scrollback",
    dir,
    root .. "/viewer/init.lua",
    "/opt/homebrew/bin/nvim",
  }
end
---@param ctx RexContext
---@return string
local function placement(ctx)
  local result =
    call("session.describe_block", { session_id = ctx.session_id, block_id = ctx.block_id })
  local b = check(result.block, "source is not a placed terminal")
  check(
    b
      and b.block_id == ctx.block_id
      and b.creator_name == terminal
      and b.placement == "placed"
      and type(b.window_id) == "string"
      and b.window_id ~= "",
    "source is not a placed terminal"
  )
  return b.window_id
end
---@param argv string[]
---@return RexExecResult
local function exec(argv)
  local result = check(rex.exec(argv, { timeout = 5 }), "private storage operation failed")
  check(result.ok, "private storage operation failed")
  return result
end
---@param ctx RexContext
---@param root string
---@return RexCallResult
function M.run(ctx, root)
  check(ctx.session_id and ctx.block_id, "invoking terminal IDs required")
  local window = placement(ctx)
  ---@type string?
  local text = M.capture(ctx)
  check(placement(ctx) == window, "source window changed during capture")
  local dir, layer, file
  local ok, result = pcall(function()
    local output = exec({ "/usr/bin/mktemp", "-d", "/tmp/rex-scrollback.XXXXXXXX" }).stdout
    dir = check(
      type(output) == "string" and output:match("^(/tmp/rex%-scrollback%.[%w]+)\n$"),
      "invalid private directory"
    )
    exec({ "/bin/chmod", "700", dir })
    file = check(io.open(dir .. "/snapshot", "wb"), "cannot create snapshot")
    exec({ "/bin/chmod", "600", dir .. "/snapshot" })
    check(file:write(text), "cannot write snapshot")
    check(file:close(), "cannot close snapshot")
    file = nil
    text = nil
    check(placement(ctx) == window, "source window changed before launch")
    local created = call("session.new_layer", {
      session_id = ctx.session_id,
      window_id = window,
      bounds = { 0.05, 0.05, 0.9, 0.9 },
      focus = false,
      layout = rex.layout.block({
        flavor = "com.superlogical.terminal.shell",
        options = {
          command = M.command(dir, root),
          shell = "none",
          exit = { on_completion = true, quick_exit_threshold_ms = 0 },
        },
      }),
    })
    layer = created.layer_id
    check(
      type(layer) == "string"
        and created.block_ids
        and #created.block_ids == 1
        and type(created.block_ids[1]) == "string",
      "invalid viewer placement"
    )
    -- Creation does not focus. Revalidate the pinned source before focusing only
    -- the returned viewer block, never the currently active pane or window.
    check(placement(ctx) == window, "source window changed during launch")
    call("session.focus_block", { session_id = ctx.session_id, block_id = created.block_ids[1] })
    return created
  end)
  if not ok then
    local owned_file = file
    if owned_file then
      pcall(function()
        owned_file:close()
      end)
    end
    if layer then
      rex.call("session.close_layer", { session_id = ctx.session_id, layer_id = layer })
    end
    if dir then
      os.remove(dir .. "/snapshot")
      rex.exec({ "/bin/rmdir", "--", dir }, { timeout = 5, stdout = false, stderr = false })
    end
    -- Only our constant errors are exposed, never filesystem/server payloads.
    error("Scrollback viewer: could not open isolated snapshot viewer", 0)
  end
  return result
end
---@param root string
function M.register(root)
  rex.action({
    name = "scrollback_viewer",
    title = "View terminal scrollback snapshot",
    category = "Pane",
    description = "Plain-text screen and scrollback snapshot; not application-internal history or native copy mode.",
    run = function(ctx)
      return M.run(ctx, root)
    end,
  })
  rex.action({
    name = "scrollcopy",
    title = "Open scrollback snapshot for copying",
    category = "Pane",
    description = "Open an isolated snapshot viewer; leave key modes only after successful launch.",
    run = function(ctx)
      -- Queue first so a missing client fails before viewer creation. Rex drains
      -- this after successful callback return, not before capture or launch.
      rex.client.queue("client.mode.exit_all")
      return M.run(ctx, root)
    end,
  })
end
return M
