local wezterm = require 'wezterm';

-- A helper function for my fallback fonts
function font_with_fallback(name, params)
  local names = {name, "Noto Color Emoji", "FuraCode Nerd Font"}
  return wezterm.font_with_fallback(names, params)
end

return {
  -- Font
  font_size = 10.0,
  font_antialias = "Greyscale", -- None, Greyscale, Subpixel
  font_hinting = "None",  -- None, Vertical, VerticalSubpixel, Full
  line_height = 1.2,

  font = font_with_fallback("Operator Mono Ssm Lig Book"),
  font_rules= {
    -- Select a fancy italic font for italic text
    {
      italic = true,
      font = font_with_fallback("Operator Mono Ssm Lig Book Italic"),
    },

    -- Similarly, a fancy bold+italic font
    {
      italic = true,
      intensity = "Bold",
      font = font_with_fallback("Operator Mono Ssm Lig Bold Italic"),
    },

    -- Make regular bold text a different color to make it stand out even more
    {
      intensity = "Bold",
      font = font_with_fallback("Operator Mono Ssm Lig Bold"),
    },

    -- For half-intensity text, use a lighter weight font
    {
      intensity = "Half",
      font = font_with_fallback("Operator Mono Ssm Lig Medium"),
    },
  },

  -- Colors
  color_scheme_dirs = {"/Users/Felix/.config/wezterm/colors"},
  color_scheme = "MaterialPalenight",

  -- Appearance
  enable_tab_bar = false,
  default_cursor_style = "SteadyUnderline",
  window_padding = {
    left = 12,
    right = 12,
    top = 0,
    bottom = 12,
  }
}
