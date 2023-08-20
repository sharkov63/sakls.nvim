---Managing SAKLS engine attached to a Vim buffer.

local M = {}

local vim = vim
local m_capi = require 'sakls.capi'
local m_layout_backend = require 'sakls.layout_backend'

local augroup

---Initialize this module.
function M.init()
  augroup = vim.api.nvim_create_augroup('SaklsNvim_Engine', {})
end

---A global table which maps buffer numbers (non-zero) to
---SAKLS engine handles attached to them.
M.buf_to_engine = {}

---Set up an autocommand, which destructs the attached engine.
---
---@param bufnr integer Buffer ID (non-zero).
---@param engine any Engine handle attached to the buffer.
---@param capi any SAKLS C API namespace in FFI.
local function set_up_delete_autocmd(bufnr, engine, capi)
  vim.api.nvim_create_autocmd({ 'BufDelete', 'VimLeavePre' }, {
    group = augroup,
    buffer = bufnr,
    callback = function()
      M.buf_to_engine[bufnr] = nil
      capi.sakls_Engine_delete(engine)
    end,
  })
end

---@param bufnr integer Buffer ID (non-zero).
---@param capi any SAKLS C API namespace in FFI.
---@param layout_backend any Layout backend handle.
local function attach_impl(bufnr, capi, layout_backend)
  local engine =
    capi.sakls_Engine_createWithDefaultSchema(layout_backend.handle)
  M.buf_to_engine[bufnr] = engine
  set_up_delete_autocmd(bufnr, engine, capi)
end

---Attach a new SAKLS engine to a Vim buffer.
---
---This engine will automatically be cleaned up upon
---destruction of the buffer.
---
---@param schema? any SAKLS schema (TODO: add support for it).
---@param bufnr? integer Buffer ID, or 0/nil for current buffer.
---@param capi? any SAKLS C API namespace in FFI.
---If nil, it's taken from capi module.
---@param layout_backend? any Layout backend handle.
---If nil, the global one is taken.
function M.attach_to_buf(schema, bufnr, capi, layout_backend)
  bufnr = bufnr or 0
  if bufnr == 0 then
    bufnr = vim.api.nvim_get_current_buf()
  end
  capi = capi or m_capi
  layout_backend = layout_backend or m_layout_backend
  attach_impl(bufnr, capi, layout_backend)
end

return M
