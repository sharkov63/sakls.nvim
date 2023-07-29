---sakls.nvim: Syntax-Aware Keyboard Layout Switching (SAKLS) Neovim plugin.
---
---Entry point of the plugin.

local M = {}

local options = require 'sakls.options'
local log = require 'sakls.support.log'
local capi = require 'sakls.capi'

---Initialize sakls.nvim plugin:
--- * Load SAKLS shared library into memory.
--- * Prepare a layout API implementation (selected by user).
--- * Set up necessary autocommands and utilities for SAKLS.
---
---@param user_options any Raw, unprocessed user options for sakls.nvim.
function M.init(user_options)
  options.set_current_options(options.validate(user_options))
  capi.set_current(capi.load())

  log.info 'Hello World! Options:'
  log.info(vim.inspect(options))
  log.info 'capi:'
  log.info(vim.inspect(capi))
end

return M
