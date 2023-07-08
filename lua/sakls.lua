---Syntax-Aware Keyboard Layout Switching (SAKLS).
---Entry point of the plugin.

local M = {}

local options = require 'sakls.options'
local log = require 'sakls.support.log'

---Set up sakls.nvim plugin.
---
---@param opts table Raw user options for sakls plugin.
function M.setup(opts)
  opts = options.validate(opts)
  log.info 'Hello World! Options:'
  log.info(vim.inspect(opts))
end

return M
