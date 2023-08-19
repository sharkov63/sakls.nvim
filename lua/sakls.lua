---sakls.nvim: Syntax-Aware Keyboard Layout Switching (SAKLS) Neovim plugin.
---
---Entry point of the plugin.

local M = {}

local options = require 'sakls.options'
local capi = require 'sakls.capi'
local layout_backend = require 'sakls.layout_backend'

---Initialize sakls.nvim plugin:
--- * Load SAKLS shared library into memory.
--- * Prepare the SAKLS layout backend, selected by user.
--- * Set up necessary autocommands and utilities for SAKLS.
---
---@param user_options any Raw, unprocessed user options for sakls.nvim.
function M.init(user_options)
  options.set_current_options(options.validate(user_options))

  capi.declare()
  capi.set_current(capi.load())

  layout_backend.set_current(layout_backend.create())
  layout_backend.set_up_deletion()
end

return M
