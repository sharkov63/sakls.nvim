---Implementation of Layout API with xkb-switch library:
---real switching of system keyboard layout for platforms
---with X keyboard extension (XKB).

local M = {}

local libcall = vim.fn.libcall
local filereadable = vim.fn.filereadable

---Produce an xkb-switch Layout API implementation.
---
---@param lib_path string Absolute path to xkb-switch shared library
---(usually named like 'libxkbswitch.so').
---@param default_layout string Default layout (usually 'us').
---
---@return LayoutAPI? # Layout API implementation on success,
---nil on failure.
function M.produce(lib_path, default_layout)
  if not filereadable(lib_path) then
    return
  end
  return {
    default_layout = default_layout,
    get_layout = function()
      return libcall(lib_path, 'Xkb_Switch_getXkbLayout', '')
    end,
    set_layout = function(layout)
      libcall(lib_path, 'Xkb_Switch_setXkbLayout', layout)
    end,
  }
end

return M
