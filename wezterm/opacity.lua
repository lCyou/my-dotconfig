local wezterm = require("wezterm")

local M = {}

-- Opacity切り替え用の状態管理
local default_opacity = 0.70 --デフォルト値
local is_transparent = true


-- Opacity切り替え関数
M.toggle = function(window, pane)
  local overrides = window:get_config_overrides() or {}
  if is_transparent then
    overrides.window_background_opacity = 1.0
    is_transparent = false
  else
    overrides.window_background_opacity = default_opacity
    is_transparent = true
  end
  window:set_config_overrides(overrides)
end

return M
