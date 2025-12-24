-- lua/huey/utils.lua
local M = {}
local api = vim.api
local lighten_hex = require("volt.color").change_hex_lightness

M.hex_on_cursor = function()
  local hex = vim.fn.expand "<cword>"
  
  if hex:match "^#?%x%x%x%x%x%x$" then
    return hex:gsub("#", "")
  end
end

-- lightens hex color under cursor, negative arg will darken
M.lighten_on_cursor = function(n)
  local cword = vim.fn.expand("<cword>")
  if not cword:match("^#?%x%x%x%x%x%x$") then
    return
  end

  local hex = cword:gsub("#", "")
  local new_hex = lighten_hex("#" .. hex, n)

  local replacement = new_hex:sub(2)
  if cword:match("^#") then
    replacement = new_hex
  end

  local row, col = unpack(api.nvim_win_get_cursor(0))
  local buf = api.nvim_get_current_buf()
  M.replace_word_at_cursor(buf, row, col, cword, replacement)
end

M.replace_word_at_cursor = function(buf, row, col, word, replacement)
  local line = api.nvim_buf_get_lines(buf, row - 1, row, true)[1]
  if not line then
    return
  end

  local start_col_byte
  local search_start = 1
  while true do
    local s, e = line:find(word, search_start, true)
    if not s then
      break
    end

    if col >= (s - 1) and col < e then
      start_col_byte = s - 1
      break
    end
    search_start = e + 1
  end

  if start_col_byte then
    api.nvim_buf_set_text(buf, row - 1, start_col_byte, row - 1, start_col_byte + #word, { replacement })
  end
end

return M
