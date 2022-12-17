-- File:        defaults.lua
-- Author:      Zakhary Kaplan <https://zakhary.dev>
-- Created:     20 Jul 2022
-- SPDX-License-Identifier: MIT

return {
  -- Highlight group to use for trailing whitespace.
  hlgroup = "Search",
  -- Pattern to match trailing whitespace against. Edit with caution!
  pattern = "\\v((.*%#)@!|%#)\\s+$",
  -- Enabled filetypes.
  filetype = {
    -- Strictly enable only on `include`ed filetypes. When false, only disabled
    -- on an `exclude`ed filetype.
    strict = false,
    -- Included filetype list.
    include = {},
    -- Excluded filetype list. Overrides `include` list.
    exclude = {
      "",
      "alpha",
      "aerial",
      "checkhealth",
      "diff",
      "lspinfo",
      "man",
      "mason",
      "cmp_menu",
      "TelescopePrompt",
      "Trouble",
      "WhichKey",
    },
  },
  -- Enabled buftypes.
  buftype = {
    -- Strictly enable only on `include`ed buftypes. When false, only disabled
    -- on an `exclude`ed buftype.
    strict = false,
    -- Included filetype list. Overrides `include` list.
    include = {},
    -- Excluded filetype list.
    exclude = {
      "help",
      "terminal",
      "quickfix",
      "prompt",
      "nofile",
    }
  },
  -- Trim on write behaviour.
  trim = {
    -- Auto trim on BufWritePre
    auto = true,
    -- Trailing whitespace as highlighted.
    whitespace = true,
    -- Final blank (i.e. whitespace only) lines.
    blanklines = false,
  }
}
