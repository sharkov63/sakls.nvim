---A LuaJIT FFI-driven bridge
---between C API of SAKLS library and sakls.nvim plugin.

local M = {}

local ffi = require 'ffi'
local options = require 'sakls.options'

---Declare SAKLS C API functions in LuaJIT FFI.
function M.declare()
  ffi.cdef [[
typedef uint64_t sakls_SyntaxNodeType;
struct sakls_SyntaxNode {
  sakls_SyntaxNodeType type;
};
struct sakls_SyntaxStackRef {
  struct sakls_SyntaxNode *data;
  size_t size;
};

void *sakls_Engine_createWithDefaultSchema(void *layoutBackend);
int sakls_Engine_reset(void *engine);
int sakls_Engine_setNewSyntaxStack(void *engine,
                                   struct sakls_SyntaxStackRef synStack,
                                   int force);
void sakls_Engine_delete(void *engine);

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
