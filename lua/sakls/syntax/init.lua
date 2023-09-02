---Obtaining syntax information as input to SAKLS engine.

local M = {}

local ffi = require 'ffi'

---@alias SyntaxStack integer[]
---
---Represents syntax stack as a lua array of integer syntax node types.
---
---Top of the stack is the last element of the array,
---bottom - is the first.

---@class SyntaxProvider
---
---Provides syntax stack as input to SAKLS engine.
---
---@field get_syntax_stack fun(): SyntaxStack
---Get currently observed syntax stack.
---@field schema_translator? fun(string): integer
---If exists, translates string syntax node types (seen in schema)
---into integer syntax node types. This way the translation
---is done on the sakls.nvim plugin side, not on the SAKLS engine side.

---Convert lua SyntaxStack into sakls_SyntaxStackRef
---from SAKLS C API as a FFI cdata.
---
---The caller takes the ownership of the returned syntax stack.
---
---@param syntax_stack SyntaxStack
---@return any # A FFI cdata: sakls_SyntaxStackRef.
function M.convert_to_c_syntax_stack(syntax_stack)
  local size = #syntax_stack
  local c_array = ffi.new('struct sakls_SyntaxNode[?]', size)
  for index = 1, size do
    c_array[index - 1].type = syntax_stack[index]
  end
  local c_syntax_stack = ffi.new('struct sakls_SyntaxStackRef')
  c_syntax_stack.data = c_array
  c_syntax_stack.size = size
  return c_syntax_stack
end

return M
