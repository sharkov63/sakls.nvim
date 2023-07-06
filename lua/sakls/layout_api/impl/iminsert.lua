---Implementation of Layout API, which toggles 'iminsert' option in Vim.
---
---Useful in cases when there is no library implementing system keyboard
---layout switching and one should rely on builtin Vim 'keymap' mechanism.

---@type LayoutAPI
local M = {}

local o = vim.o

---@type LayoutID
M.default_layout = 0

---@return LayoutID
function M.get_layout()
  return o.iminsert
end

---@param layout LayoutID
function M.set_layout(layout)
  o.iminsert = layout
end

return M
