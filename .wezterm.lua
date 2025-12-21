local wezterm = require 'wezterm'
local act = wezterm.action

wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  local gui_win = window:gui_window()
  gui_win:maximize()
end)

return {
  color_scheme = "Gruvbox Dark (Gogh)",
  font = wezterm.font_with_fallback({
    "JetBrainsMono Nerd Font",
  }),
  font_size = 15.0,
  window_decorations = "RESIZE",
  hide_tab_bar_if_only_one_tab = true,
  use_fancy_tab_bar = true,
  window_close_confirmation = "NeverPrompt",

  keys = {
    { key = "D", mods = "CMD|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "E", mods = "CMD|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "LeftArrow",  mods = "CMD|OPT", action = act.ActivatePaneDirection("Left") },
    { key = "RightArrow", mods = "CMD|OPT", action = act.ActivatePaneDirection("Right") },
    { key = "UpArrow",    mods = "CMD|OPT", action = act.ActivatePaneDirection("Up") },
    { key = "DownArrow",  mods = "CMD|OPT", action = act.ActivatePaneDirection("Down") },
    { key = "W", mods = "CMD|SHIFT", action = act.CloseCurrentPane({ confirm = false }) },
  },
}

