---sakls options and their validation.

local M = {}

local log = require 'sakls.support.log'

---@class Options
---
---Validated user options of sakls plugin.
---
---@field layout_api LayoutAPIOptions

---@class LayoutAPIOptions
---
---Specifies chosen implementation of Layout API.
---
---@field impl? string Defines which implementation of Layout API to use.
---@field libpath? string For implementations which depend on an external
---library: provide an optional path to that library.

---Default options table.
---
---User options fall back to the default in case
--- * when an option is not provided;
--- * when an option is invalid (with issuing a warning).
---
---@type Options
local default_options = {
  layout_api = {
    impl = nil,
    libpath = nil,
  },
}

---Ensure that a non-nil field has a specified type
---(if not, make it nil).
---
---@param parent table Table which has a non-nil field `field`.
---@param field string Field to validate.
---@param ty string Expected type.
---@param prefix string Prefix of the field to be printed in a warning.
local function validate_type(parent, field, ty, prefix)
  prefix = prefix or ''
  if type(parent[field]) ~= ty then
    log.warn(
      '%s%s option: expected type %s, got %s; '
        .. "falling back to its' default value",
      prefix,
      field,
      ty,
      type(parent[field])
    )
    parent[field] = nil
  end
end

---Validate "layout_api.impl" option.
---
---@param layout_api table layout_api option table being validated;
---it has non-nil `impl` field.
local function validate_layout_api_impl(layout_api)
  validate_type(layout_api, 'impl', 'string', 'layout_api.')
  if not layout_api.impl then
    return
  end
  local valid_values = {
    ['iminsert'] = true,
    ['xkb-switch'] = true,
  }
  if not valid_values[layout_api.impl] then
    log.warn(
      "layout_api.impl has unsupported value '%s'; "
        .. "falling back to its' default value nil",
      layout_api.impl
    )
    layout_api.impl = nil
  end
end

---Validate "layout_api" option.
---
---@param opts table Options table being validated;
---it has non-nil `layout_api` field.
local function validate_layout_api(opts)
  if type(opts.layout_api) ~= 'table' then
    log.warn(
      'layout_api option is not a table: '
        .. "falling back to its' default value"
    )
    opts.layout_api = nil
    return
  end
  local layout_api = opts.layout_api
  local validator_map = {
    impl = validate_layout_api_impl,
    libpath = function(parent)
      validate_type(parent, 'libpath', 'string', 'layout_api.')
    end,
  }
  for option, _ in pairs(layout_api) do
    local validator = validator_map[option]
    if validator then
      validator(layout_api)
    else
      log.warn('Unknown option "layout_api.%s"', option)
      layout_api[option] = nil
    end
  end
  if layout_api.libpath and not layout_api.impl then
    log.warn(
      'layout_api.libpath specified without layout_api.impl: discarding it'
    )
    layout_api.libpath = nil
  end
  setmetatable(layout_api, { __index = default_options.layout_api })
end

---Validate user-provided options.
---
---@param opts any Raw options provided by the user. In case if it's a table,
---it may be modified in-place.
---@return Options # Validated options table.
function M.validate(opts)
  if type(opts) ~= 'table' then
    log.warn 'User options is not a table; falling back to default options'
    return default_options
  end
  local validator_map = {
    layout_api = validate_layout_api,
  }
  for option, _ in pairs(opts) do
    local validator = validator_map[option]
    if validator then
      validator(opts)
    else
      log.warn('Unknown option "%s"', option)
      opts[option] = nil
    end
  end
  setmetatable(opts, { __index = default_options })
  return opts
end

return M
