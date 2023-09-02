---VimSyn: syntax provider based on native Vim synstack() method.

local vim = vim

---Get cursor position in the current window,
---with some adjustments.
---
---@return integer row
---@return integer col
local function get_position()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  if vim.api.nvim_get_mode().mode:sub(1, 1) ~= 'i' then
    col = col + 1
  end
  if col <= 0 then
    col = 1
  end
  return row, col
end

---Get Vim native syntax stack at the cursor position in the current window.
---
---@return SyntaxStack
local function get_syntax_stack()
  local row, col = get_position()
  return vim.fn.synstack(row, col)
end

---@type SyntaxProvider
local M = {
  get_syntax_stack = get_syntax_stack,
  schema_translator = vim.fn.hlID,
}

return M
