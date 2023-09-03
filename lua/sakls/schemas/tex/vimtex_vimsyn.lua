---@class Schema
---
---A SAKLS schema for working with TeX documents in two languages,
---with VimTeX plugin providing syntax nodes
---via the native Vim syntax provider (vimsyn).
---
---This schema assumes that 0 is the default layout (usually English),
---and 1 is the alternative layout (other language, e.g. Russian).
local vimtex_vimsyn_schema = {
  memorized = {
    ['texAuthorArg'] = 1,
    ['texTitleArg'] = 1,
    ['texStyleBold'] = 1,
    ['texStyleItal'] = 1,
    ['texStyleArgConc'] = 1,
    ['texPartArgTitle'] = 1,
    ['texNewthmArgPrinted'] = 1,
    ['texTheoremEnvOpt'] = 1,
    ['texEnvOpt'] = 1,
    ['texMathTextConcArg'] = 1,
    ['texFootnoteArg'] = 1,
  },
  forced = {
    [''] = 1,
  },
  ignored = {
    ['texDelim'] = true,
    ['texMathDelimZoneTI'] = true,
    ['texRefEqConcealedDelim'] = true,
    ['texGroup'] = true,
    ['texSpecialChar'] = true,
  },
}
return vimtex_vimsyn_schema
