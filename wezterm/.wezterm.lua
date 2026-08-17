-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.initial_cols = 40
config.initial_rows = 12

-- or, changing the font size and color scheme.
config.font_size = 12
config.color_scheme = 'Catppuccin Mocha'

config.dpi = 192.0
config.window_decorations = 'RESIZE'
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
config.font = wezterm.font 'MesloLGS NF'
config.window_background_opacity = 0.85

-- Finally, return the configuration to wezterm:
return config
