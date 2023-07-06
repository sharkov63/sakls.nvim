---Mock implementation of Layout API, which operates on a local variable.
---
---Useful for unit-testing.

local M = {}

---Produce a new mock implementation of Layout API.
---
---@param default_layout? LayoutID Default layout of this implementation
---('us' if it's not provided).
---@return LayoutAPI
function M.produce(default_layout)
  default_layout = default_layout or 'us'
  local current_layout = default_layout
  return {
    default_layout = default_layout,
    get_layout = function()
      return current_layout
    end,
    set_layout = function(layout)
      current_layout = layout
    end,
  }
end

return M
