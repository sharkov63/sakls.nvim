---Manipulation of SAKLS layout backend through SAKLS C API.

local M = {}

local vim = vim
local ffi = require 'ffi'
local options = require 'sakls.options'

---@class LayoutBackend
---
---Lua table representing SAKLS layout backend.
---
---@field handle any A FFI cdata - a raw pointer to sakls::ILayoutBackend.
---@field delete function Callback, which deletes this layout backend.
---Does not accept arguments or return anything.

---Create xkb-switch SAKLS layout backend.
---
---@param capi any SAKLS C API namespace in FFI.
---
---@return LayoutBackend
local function create_xkb_switch_backend(capi)
  local handle_arr = ffi.new('void *[1]')
  local error_code = capi.sakls_XkbSwitch_createLayoutBackend(handle_arr)
  if error_code ~= 0 then
    error(
      'Unable to load xkb-switch SAKLS layout backend:\n'
        .. ' sakls_XkbSwitch_createLayoutBackend returned error code '
        .. error_code,
      3
    )
  end
  local handle = handle_arr[0]
  return {
    handle = handle,
    delete = function()
      capi.sakls_XkbSwitch_deleteLayoutBackend(handle)
    end,
  }
end

---Mapping from layout backend names to creation functions.
local create_mapping = {
  ['xkb-switch'] = create_xkb_switch_backend,
}

---Create a SAKLS layout backend.
---
---@param backend_name? string Name of the layout backend.
---If nil, it's taken from global options table.
---@param capi? any SAKLS C API namespace in FFI.
---If nil, it's taken from capi module.
---
---@return LayoutBackend
function M.create(backend_name, capi)
  backend_name = backend_name or options.layout_backend
  capi = capi or require 'sakls.capi'
  local create = create_mapping[backend_name]
  if not create then
    error('Invalid layout backend name "' .. backend_name .. '"')
  end
  return create(capi)
end

---Set current global layout backend.
---
---@param layout_backend LayoutBackend
function M.set_current(layout_backend)
  setmetatable(M, { __index = layout_backend })
end

---Set up an autocommand, which destructs layout backend before Vim is exited.
---
---@param layout_backend? any Layout backend handle.
---If nil, the global one is taken.
function M.set_up_deletion(layout_backend)
  layout_backend = layout_backend or M
  local augroup =
    vim.api.nvim_create_augroup('SaklsNvim_LayoutBackendDelete', {})
  vim.api.nvim_create_autocmd('VimLeavePre', {
    group = augroup,
    callback = layout_backend.delete,
  })
end

return M
