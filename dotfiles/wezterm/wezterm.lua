local wezterm = require("wezterm")
local config = wezterm.config_builder()

config = {
    enable_tab_bar = false,
    enable_scroll_bar = false,
    scrollback_lines = 10000,
}

return config
