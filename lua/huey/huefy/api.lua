-- lua/huey/huefy/api.lua
local M = {}
local v = require "huey.huefy.state"

M.save_color = function()
  require("volt").close()
  local line = vim.api.nvim_get_current_line()
  line = line:gsub(v.hex, v.new_hex, 1)
  vim.api.nvim_set_current_line(line)
end

return M
