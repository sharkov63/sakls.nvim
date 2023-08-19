---A LuaJIT FFI-driven bridge
---between C API of SAKLS library and sakls.nvim plugin.

local M = {}

local ffi = require 'ffi'
local options = require 'sakls.options'

---Declare SAKLS C API functions in LuaJIT FFI.
function M.declare()
  ffi.cdef [[
int sakls_XkbSwitch_createLayoutBackend(void **layoutBackend);
void sakls_XkbSwitch_deleteLayoutBackend(void *layoutBackend);
]]
end

---Load the SAKLS shared library and return SAKLS C API namespace.
---
---@param sakls_lib_options? SAKLSLibOptions
function M.load(sakls_lib_options)
  sakls_lib_options = sakls_lib_options or options.sakls_lib
  local lib_identifier = sakls_lib_options.path or 'SAKLS'
  return ffi.load(lib_identifier)
end

---Set current global SAKLS C API namespace.
function M.set_current(capi)
  setmetatable(M, { __index = capi })
end

return M
