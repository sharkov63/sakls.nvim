---sakls.nvim: Syntax-Aware Keyboard Layout Switching (SAKLS) Neovim plugin.
---
---Entry point of the plugin.

local M = {}

local m_options = require 'sakls.options'
local m_capi = require 'sakls.capi'
local m_layout_backend = require 'sakls.layout_backend'
local m_engine = require 'sakls.engine'

---Initialize sakls.nvim plugin:
--- * Load SAKLS shared library into memory.
--- * Prepare the SAKLS layout backend, selected by user.
--- * Set up necessary autocommands and utilities for SAKLS.
---
---@param user_options any Raw, unprocessed user options for sakls.nvim.
function M.init(user_options)
  m_options.set_current_options(m_options.validate(user_options))

  m_capi.declare()
  m_capi.set_current(m_capi.load())

  m_layout_backend.set_current(m_layout_backend.create())
  m_layout_backend.set_up_deletion()

  m_engine.init()
end

return M
