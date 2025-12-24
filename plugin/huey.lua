-- plugin/huey.lua
local cmd = vim.api.nvim_create_user_command

cmd("Huefy", function()
  require("huey.huefy").open()
end, { desc = "Open huey huefy color picker" })

cmd("Shades", function()
  require("huey.shades").open()
end, { desc = "Open huey shades color tool" })
