---User options of sakls.nvim and their validation.

local M = {}

local log = require 'sakls.support.log'

---@class Options
---
---Validated user options of sakls.nvim.
---
---@field sakls_lib SAKLSLibOptions
---@field layout_backend string Name of the SAKLS layout backend to use.
---Currently supported values are:
---  * 'xkb-switch' for xkb-switch layout backend.

---@class SAKLSLibOptions
---
---Settings for SAKLS library.
---
---@field path string Name, or path of SAKLS library.
---If a path is provided, the library will be taken at that path.
---If a name is provided, sakls.nvim will look for a system-installed
---SAKLS library.

---Default user options.
---
---Provided options will fall back to the default in case
--- * when an option is not provided;
--- * when an option is invalid (a warning will be issued in this case).
---
---@type Options
local default_options = {
  sakls_lib = {
    path = 'SAKLS',
  },
  layout_backend = '<INVALID>',
}

---Ensure that a non-nil field of a table has a specified type
---(if not, make it nil and issue a warning).
---
---@param parent table Table which has a non-nil field `field`.
---@param field string Field to validate.
---@param ty string Expected type.
---@param prefix string Prefix of the field to be printed in a warning.
---
---@return boolean valid True iff the field has the required type.
local function validate_type(parent, field, ty, prefix)
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
    return false
  end
  return true
end

---Validate a "subtable" of options.
---
---@param user table User options subtable.
---@param default table Corresponding default options subtable.
---@param prefix string Prefix of the subtable to be printed in a warning.
local function validate_recursive(user, default, prefix)
  for option, user_value in pairs(user) do
    local default_value = default[option]
    if not default_value then
      log.warn('Unknown option %s%s', prefix, option)
      user[option] = nil
    elseif
      validate_type(user, option, type(default_value), prefix)
      and type(default_value) == 'table'
    then
      validate_recursive(user_value, default_value, prefix .. option .. '.')
    end
  end
  setmetatable(user, { __index = default })
end

---Validate, modifying when necessary, provided options.
---
---@param user any Raw options provided by the user. In case if it's a table,
---it may be modified in-place.
---@return Options # Validated options table.
function M.validate(user)
  if type(user) ~= 'table' then
    log.warn 'User options is not a table; falling back to default options'
    return default_options
  end
  validate_recursive(user, default_options, '')
  return user
end

---Set current global options.
---
---@param options Options
function M.set_current_options(options)
  setmetatable(M, { __index = options })
end

return M
