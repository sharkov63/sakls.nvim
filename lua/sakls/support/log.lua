--- Convenient logging utilities.

local M = {}

local vim = vim
local notify_once = vim.notify_once
local levels = vim.log.levels
local format = string.format

function M.trace(fmt, ...)
  notify_once(format('[sakls] ' .. fmt, ...), levels.TRACE)
end

function M.debug(fmt, ...)
  notify_once(format('[sakls] ' .. fmt, ...), levels.DEBUG)
end

function M.info(fmt, ...)
  notify_once(format('[sakls] ' .. fmt, ...), levels.INFO)
end

function M.warn(fmt, ...)
  notify_once(format('[sakls] ' .. fmt, ...), levels.WARN)
end

function M.error(fmt, ...)
  notify_once(format('[sakls] ' .. fmt, ...), levels.ERROR)
end

return M
