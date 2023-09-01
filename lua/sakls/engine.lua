---SAKLS engine, attached to a Vim buffer.

local M = {}

local vim = vim
local m_capi = require 'sakls.capi'
local m_layout_backend = require 'sakls.layout_backend'
local m_syntax = require 'sakls.syntax'

local augroup = vim.api.nvim_create_augroup('SaklsNvim_Engine', {})

---A global table which maps buffer numbers (non-zero) to
---SAKLS engine handles attached to them.
M.buf_to_engine = {}

---@param bufnr integer Buffer ID, or 0/nil for current buffer.
---@return integer # Actual non-zero buffer ID.
local function get_actual_bufnr(bufnr)
  if bufnr == 0 then
    return vim.api.nvim_get_current_buf()
  end
  return bufnr
end

---@param bufnr integer Buffer ID (non-zero).
---@param capi any SAKLS C API namespace in FFI.
local function delete_impl(bufnr, capi)
  local engine = M.buf_to_engine[bufnr]
  if engine then
    M.buf_to_engine[bufnr] = nil
    capi.sakls_Engine_delete(engine)
  end
end

---Set up an autocommand, which destructs the attached engine.
---
---@param bufnr integer Buffer ID (non-zero).
---@param capi any SAKLS C API namespace in FFI.
local function set_up_delete_autocmd(bufnr, capi)
  vim.api.nvim_create_autocmd({ 'BufDelete', 'VimLeavePre' }, {
    group = augroup,
    buffer = bufnr,
    callback = function()
      delete_impl(bufnr, capi)
    end,
  })
end

---@param bufnr integer Buffer ID (non-zero).
---@param syntax_provider SyntaxProvider
---@param engine any Engine handle attached to the buffer.
---@param capi any SAKLS C API namespace in FFI.
local function set_up_autocmds_new_syntax_stack(
  bufnr,
  syntax_provider,
  engine,
  capi
)
  local function set_new_syntax_stack()
    capi.sakls_Engine_setNewSyntaxStack(
      engine,
      m_syntax.convert_to_c_syntax_stack(syntax_provider.get_syntax_stack()),
      true -- force
    )
  end
  vim.api.nvim_create_autocmd('InsertEnter', {
    buffer = bufnr,
    group = augroup,
    callback = set_new_syntax_stack,
  })
  vim.api.nvim_create_autocmd(
    { 'CursorMovedI', 'TextChangedI', 'InsertChange' },
    {
      buffer = bufnr,
      group = augroup,
      callback = set_new_syntax_stack,
    }
  )
  vim.api.nvim_create_autocmd('InsertLeavePre', {
    buffer = bufnr,
    group = augroup,
    callback = function()
      capi.sakls_Engine_reset(engine)
    end,
  })
  vim.api.nvim_create_autocmd('ModeChanged', {
    buffer = bufnr,
    group = augroup,
    callback = function()
      if vim.fn.mode() ~= 's' then
        return
      end
      set_new_syntax_stack()
    end,
  })
end

---@param bufnr integer Buffer ID (non-zero).
---@param syntax_provider SyntaxProvider
---@param capi any SAKLS C API namespace in FFI.
---@param layout_backend any Layout backend handle.
local function attach_impl(bufnr, syntax_provider, capi, layout_backend)
  local engine =
    capi.sakls_Engine_createWithDefaultSchema(layout_backend.handle)
  M.buf_to_engine[bufnr] = engine
  set_up_delete_autocmd(bufnr, capi)
  set_up_autocmds_new_syntax_stack(bufnr, syntax_provider, engine, capi)
end

---Attach a new SAKLS engine to a Vim buffer.
---
---This engine will automatically be deleted upon
---destruction of the buffer.
---
---@param bufnr integer Buffer ID, or 0 for current buffer.
---@param syntax_provider SyntaxProvider Chosen syntax provider.
---@param schema? any SAKLS schema (TODO: add support for it).
---@param capi? any SAKLS C API namespace in FFI.
---If nil, it's taken from capi module.
---@param layout_backend? any Layout backend handle.
---If nil, the global one is taken.
function M.attach_to_buf(bufnr, syntax_provider, schema, capi, layout_backend)
  attach_impl(
    get_actual_bufnr(bufnr),
    syntax_provider,
    capi or m_capi,
    layout_backend or m_layout_backend
  )
end

---Delete SAKLS engine attached to buffer (if there is one).
---
---@param bufnr integer Buffer ID, or 0 for current buffer.
---@param capi? any SAKLS C API namespace in FFI.
---If nil, it's taken from capi module.
function M.delete_for_buf(bufnr, capi)
  delete_impl(get_actual_bufnr(bufnr), capi or m_capi)
end

return M
