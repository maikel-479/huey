# Huey

Beautifully crafted color tools for Neovim, built with the Volt UI framework.

## Features

- **Huefy**: Advanced color picker with RGB sliders, saturation/lightness controls, and complementary color suggestions
- **Shades**: Color shade generator with multiple modes (Variants, Saturation, Hues)
- Interactive UI with mouse and keyboard support
- Save colors directly to your code

## Install

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "maikel-479/volt",
  lazy = true,
}

{
  "maikel-479/huey",
  cmd = { "Shades", "Huefy" },
}
```

## Usage

### Commands

- `:Huefy` - Open the advanced color picker
- `:Shades` - Open the color shade generator

### Keyboard Controls

- `<Ctrl-t>` - Cycle through windows (Huefy only)
- `<Tab>` / `<S-Tab>` - Cycle through clickable elements
- `<CR>` (Enter) - Activate clickable element
- `<C-s>` - Save color to cursor position
- `q` / `<Esc>` - Close the tool
- `h` / `l` - Adjust sliders

### Mouse Controls

- Click on color blocks to select
- Hover over elements for visual feedback
- Click and drag on sliders

## Configuration

```lua
require("huey").setup({
  huefy = {
    border = false,
    prompt = "   Enter color : ",
    position = "cursor", -- cursor | center | func(w, h)
    mappings = function(bufs)
      -- Add custom buffer-scoped mappings
    end
  },
  shades = {
    border = true,
    prompt = "   Enter color : ",
    position = "cursor", -- cursor | center | func(w, h)
    mappings = function(buf)
      -- Add custom buffer-scoped mappings
    end
  },
})
```

## API

### Huefy

```lua
-- Open Huefy
require("huey.huefy").open()

-- Save color
require("huey.huefy.api").save_color()
```

### Shades

```lua
-- Open Shades
require("huey.shades").open()

-- Save color
require("huey.shades.api").save_color()
```

### Utility Functions

```lua
local utils = require("huey.utils")

-- Get hex color under cursor
local hex = utils.hex_on_cursor()

-- Lighten/darken color under cursor
utils.lighten_on_cursor(10)  -- lighten
utils.lighten_on_cursor(-10) -- darken
```

## Credits

This plugin is a remake of [nvzone/minty](https://github.com/nvzone/minty) using the Volt UI framework.

## License

GPL-3.0
