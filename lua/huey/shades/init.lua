-- lua/huey/shades/init.lua
local M = {}
local api = vim.api
local utils = require "huey.utils"
local v = require "huey.shades.state"
local mark_state = require "volt.state"
local redraw = require("volt").redraw
local layout = require "huey.shades.layout"
local volt = require "volt"
local config = require("huey").config.shades
local shadesapi = require "huey.shades.api"
local map = vim.keymap.set

v.ns = api.nvim_create_namespace "NvShades"

M.open = function()
  local oldwin = api.nvim_get_current_win()
  
  v.hex = utils.hex_on_cursor() or "61afef"
  v.new_hex = v.hex
  v.buf = api.nvim_create_buf(false, true)
  
  local input_buf = api.nvim_create_buf(false, true)
  vim.bo[input_buf].buftype = "prompt"
  vim.fn.prompt_setprompt(input_buf, config.prompt)
  
  volt.gen_data {
    { buf = v.buf, layout = layout, xpad = v.xpad, ns = v.ns },
  }
  
  local h = mark_state.get(v.buf).h
  
  local left_win_pos = (function()
    if config.position == "cursor" then
      return { 1, 0 }
    elseif config.position == "center" then
      return { (vim.o.lines / 2) - (h - 1 / 2), vim.o.columns / 2 - v.w / 2 }
    else
      return config.position(v.w, h - 1)
    end
  end)()
  
  local win = api.nvim_open_win(v.buf, true, {
    row = left_win_pos[1],
    col = left_win_pos[2],
    width = v.w,
    height = h,
    relative = config.position == "cursor" and "cursor" or "editor",
    style = "minimal",
    border = config.border and { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" } or "none",
    title = { { " 󱥚 Color Shades ", "pmenusel" } },
    title_pos = "center",
  })
  
  local input_win = api.nvim_open_win(input_buf, true, {
    row = h + 1,
    col = -1,
    width = v.w,
    height = 1,
    relative = "win",
    win = win,
    style = "minimal",
    border = config.border and { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" } or "none",
  })
  
  api.nvim_win_set_hl_ns(win, v.ns)
  
  if config.border then
    api.nvim_set_hl(v.ns, "FloatBorder", { link = "LineNr" })
    api.nvim_set_hl(v.ns, "Normal", { bg = "none" })
    vim.wo[input_win].winhl = "FloatBorder:ExBlue,Normal:Normal"
  else
    api.nvim_set_hl(v.ns, "FloatBorder", { link = "ExBlack2border" })
    api.nvim_set_hl(v.ns, "Normal", { link = "ExBlack2Bg" })
    vim.wo[input_win].winhl = "Normal:ExBlack3Bg,FloatBorder:ExBlack3border"
  end
  
  api.nvim_set_current_win(input_win)
  vim.cmd "startinsert"
  vim.schedule(function()
    api.nvim_set_current_win(win)
  end)
  
  volt.run(v.buf, { h = h, w = v.w })
  require("volt.events").add(v.buf)
  
  vim.fn.prompt_setcallback(input_buf, function(input)
    if not input or input == "" then
      return
    end
    local clean_hex = input
    if input:sub(1, 1) == "#" then
      clean_hex = input:sub(2)
    end

    if not (clean_hex:match("^[0-9a-fA-F]*$") and (#clean_hex == 6 or #clean_hex == 3)) then
      return
    end
    v.new_hex = clean_hex
    redraw(v.buf, { "palettes", "footer" })
  end)
  
  -- Keymaps
  volt.mappings {
    bufs = { v.buf, input_buf },
    after_close = function()
      api.nvim_set_current_win(oldwin)
    end,
  }
  
  map("n", "<C-s>", shadesapi.save_color, { buffer = v.buf })
  
  if config.mappings then
    config.mappings(v.buf)
  end
end

return M
