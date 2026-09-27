-- Liquid Glass (dark): rounded squircle windows, frosted blur, soft shadows,
-- thin light "rim" border instead of a colored one.

local active_border_color = "rgba(ffffff55)"
local inactive_border_color = "rgba(ffffff1f)"

hl.config({
  general = {
    gaps_in = 6,
    gaps_out = 12,
    border_size = 1,
    col = {
      active_border = active_border_color,
      inactive_border = inactive_border_color,
    },
  },

  decoration = {
    rounding = 18,
    rounding_power = 3.0,

    shadow = {
      enabled = true,
      range = 28,
      render_power = 3,
      color = "rgba(00000070)",
      color_inactive = "rgba(00000040)",
    },

    blur = {
      enabled = true,
      size = 12,
      passes = 3,
      noise = 0.015,
      contrast = 1.0,
      brightness = 1.0,
      vibrancy = 0.3,
      vibrancy_darkness = 0.2,
      popups = true,
      new_optimizations = true,
      xray = false,
    },
  },

  group = {
    col = {
      border_active = active_border_color,
      border_inactive = inactive_border_color,
    },
    groupbar = {
      gradient_rounding = 8,
    },
  },
})

-- Springy, iOS-like window motion.
hl.curve("glassSpring", { type = "bezier", points = { { 0.16, 1 }, { 0.3, 1.04 } } })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.2, bezier = "glassSpring", style = "popin 90%" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "glassSpring", style = "fade" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.5, bezier = "glassSpring", style = "slide" })

-- Translucent app windows (apps that opt out of default-opacity stay opaque).
o.window({ tag = "default-opacity" }, { opacity = "0.92 0.86" })

-- Terminals get their transparency from the terminal itself (text stays crisp).
o.window("^(Alacritty|kitty|foot|com.mitchellh.ghostty)$", { opacity = "1 1" })

-- Frosted glass behind the Omarchy shell surfaces.
hl.layer_rule({
  match = { namespace = "^(omarchy-bar|omarchy-notifications|omarchy-osd|omarchy-menu|omarchy-clipboard|omarchy-emojis|omarchy-polkit|omarchy-reminders|omarchy-keyboard-panel|omarchy-network-qr)$" },
  blur = true,
  blur_popups = true,
  ignore_alpha = 0.2,
})
