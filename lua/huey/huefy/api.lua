-- lua/huey/huefy/api.lua
local M = {}
local v = require "huey.huefy.state"

local utils = require "huey.utils"

M.save_color = function()
  require("volt").close()
  local old_win = vim.g.volt_old_win
  if not old_win or not vim.api.nvim_win_is_valid(old_win) then
    return
  end

  local old_buf = vim.api.nvim_win_get_buf(old_win)
  local row, col = unpack(vim.api.nvim_win_get_cursor(old_win))

  local cword = vim.fn.expand("<cword>")
  if not cword:match("^#?%x%x%x%x%x%x$") then
    cword = v.hex
  end

  local replacement = v.new_hex
  if cword:match("^#") then
    replacement = "#" .. replacement
  end

  utils.replace_word_at_cursor(old_buf, row, col, cword, replacement)
end

return M
