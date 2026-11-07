---@meta
-- Used API subset: reference-lua.md and live revision-11 schemas captured in
-- /tmp/rex-lua-quality/evidence/api-*.json. No runtime loads this definition.

---@class RexContext
---@field session_id? string
---@field block_id? string
---@field client_id? string
---@field origin? string
---@field server? string

---@class RexBlockDescription
---@field block_id string
---@field creator_name? string
---@field host_id? string
---@field placement string
---@field window_id? string

---@class RexWindowView
---@field window_id? string
---@field focused_block_id? string

---@class RexForegroundProcess
---@field pid integer
---@field cwd? string

---@class RexCallResult
---@field host_id? string
---@field active_window_id? string
---@field windows? RexWindowView[]
---@field foreground? RexForegroundProcess
---@field content? string
---@field id? integer
---@field total? integer
---@field eof? boolean
---@field data? string
---@field block? RexBlockDescription
---@field layer_id? string
---@field block_ids? string[]

---@class RexExecOptions
---@field timeout? number
---@field stdout? boolean
---@field stderr? boolean

---@class RexExecResult
---@field ok boolean
---@field stdout string
---@field stderr string
---@field code integer
---@field timed_out boolean
---@field signal? string

---@class RexTerminalOptions
---@field command string[]
---@field cwd? string
---@field shell string
---@field exit {on_completion: boolean, quick_exit_threshold_ms: integer}

---@class RexBlockLayout
---@field flavor string
---@field options RexTerminalOptions

---@class RexAction
---@field name string
---@field title string
---@field category? string
---@field description? string
---@field run fun(ctx: RexContext, args: table): RexCallResult?

---@class RexAPI
---@field bind fun(key: string, action: string, args?: table)
---@field mode fun(name: string, options?: {exclusive?: boolean})
---@field client {queue: fun(name: string, args?: table)}
---@field action fun(action: RexAction)
---@field call fun(method: string, args?: table): RexCallResult?, string?
---@field exec fun(argv: string[], opts?: RexExecOptions): RexExecResult?, string?
---@field layout {block: fun(layout: RexBlockLayout): RexBlockLayout}
rex = {}
