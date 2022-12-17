-- File:        retrail.lua
-- Author:      Zakhary Kaplan <https://zakhary.dev>
-- Created:     20 Jul 2022
-- SPDX-License-Identifier: MIT

local config = require("retrail.config")

local M = {}

local refresh

function M.setup(opts)
  -- Initialize module
  M.config   = config.parse(opts)
  M.matches  = {}
  M.override = {}

  -- Prepare autocommands
  local augroup = vim.api.nvim_create_augroup("Retrail", {})
  vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
    group = augroup,
    callback = refresh,
  })
  if M.config.trim.auto then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      callback = function()
        if M:enabled() then
          M:trim()
        end
      end,
    })
  end

  -- Create user commands
  vim.api.nvim_create_user_command("RetrailEnable", function()
    M:set(true)
  end, {
    desc = "Enable for the current buffer",
    nargs = 0,
  })

  vim.api.nvim_create_user_command("RetrailDisable", function()
    M:set(false)
  end, {
    desc = "Disable for the current buffer",
    nargs = 0,
  })

  vim.api.nvim_create_user_command("RetrailToggle", function()
    M:toggle()
  end, {
    desc = "Toggle for the current buffer",
    nargs = 0,
  })
  vim.api.nvim_create_user_command('RetrailTrimWhitespace', function()
    M:trim()
  end, {})

end

refresh = function()
  if M:enabled() then
    M:matchadd()
  else
    M:matchdelete()
  end
end

function M:set(enabled)
  -- Record the override
  self.override[vim.api.nvim_get_current_buf()] = enabled
  -- Trigger a refresh
  refresh()
end

function M:toggle()
  -- Record the override
  self.override[vim.api.nvim_get_current_buf()] = not self:enabled()
  -- Trigger a refresh
  refresh()
end

function M:enabled()
  -- Check for a buffer override
  local override = self.override[vim.api.nvim_get_current_buf()]
  if override ~= nil then
    return override
  end
  -- Check if this filetype is enabled
  local enabled_filetype = self.config.enabled_buftype[vim.bo.buftype]
  if enabled_filetype == nil then
    enabled_filetype = not self.config.filetype.strict
  end
  -- Check if this buftype is enabled
  local enabled_buftype = self.config.enabled_filetype[vim.bo.filetype]
  if enabled_buftype == nil then
    enabled_buftype = not self.config.buftype.strict
  end
  return enabled_filetype and enabled_buftype
end

function M.ident()
  local win = vim.api.nvim_get_current_win()
  local tab = vim.api.nvim_win_get_tabpage(win)
  return string.format("%d:%d", tab, win)
end

function M:matchadd()
  -- Extract match for window
  local ident = self.ident()
  local match = self.matches[ident]
  if match == nil then
    -- Add match to window
    match = vim.fn.matchadd(self.config.hlgroup, self.config.pattern)
    self.matches[ident] = match
  end
end

function M:matchdelete()
  -- Extract match for window
  local ident = M.ident()
  local match = self.matches[ident]
  if match ~= nil then
    -- Delete match from window
    pcall(vim.fn.matchdelete, match)
    self.matches[ident] = nil
  end
end

function M:trim()
  -- Save cursor position
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  -- Trim trailing whitespace
  if self.config.trim.whitespace then
    vim.cmd [[keeppatterns %s#\s\+$##e]]
  end
  -- Trim trailing blank lines
  if self.config.trim.blanklines then
    vim.cmd [[keeppatterns vg#\_s*\S#d]]
  end
  -- Restore cursor position
  vim.api.nvim_win_set_cursor(0, cursor_pos)
end

return M
