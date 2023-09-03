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
end

---Attach a SAKLS engine upon a file type encounter.
---
---For more flexible setup, one can attach a SAKLS engine manually.
---See sakls.engine.attach_to_buf function.
---
---@param filetype string|string[] Related filetype(s).
---@param syntax_provider SyntaxProvider Chosen syntax provider,
---which passes syntax information to the engine.
---@param schema? Schema A high-level SAKLS schema,
---which configures SAKLS engine. If nil, the default empty schema is taken.
function M.attach_on_filetype(filetype, syntax_provider, schema)
  local augroup = vim.api.nvim_create_augroup('Sakls_FileTypeAttach', {})
  vim.api.nvim_create_autocmd('FileType', {
    group = augroup,
    pattern = filetype,
    callback = function()
      vim.schedule(function()
        m_engine.attach_to_buf(0, syntax_provider, schema)
      end)
    end,
  })
end

return M
