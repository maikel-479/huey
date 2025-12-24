-- lua/huey/shades/layout.lua
local ui = require "huey.shades.ui"

return {
  {
    lines = ui.tabs,
    name = "tabs",
  },
  
  {
    lines = ui.palettes,
    name = "palettes",
  },
  
  {
    lines = ui.intensity,
    name = "intensity",
  },
  
  {
    lines = ui.footer,
    name = "footer",
  },
}
