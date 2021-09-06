local wezterm = require 'wezterm';

-- A helper function for my fallback fonts
function font_with_fallback(name, params)
  local names = {name, "Noto Color Emoji", "FiraCode Nerd Font"}
  return wezterm.font_with_fallback(names, params)
end

return {
  -- Font
  font_size = 12.0,
  freetype_load_target = "Light",
  line_height = 1.2,

  font = font_with_fallback("Operator Mono SSm Lig", {weight="Light"}),
  font_rules= {
    -- Select a fancy italic font for italic text
    {
      italic = true,
      font = font_with_fallback("Operator Mono SSm Lig", {italic=true, weight="Light"}),
    },

    -- Similarly, a fancy bold+italic font
    {
      italic = true,
      intensity = "Bold",
      font = font_with_fallback("Operator Mono SSm Lig", {italic=true, weight="DemiLight"}),
    },

    -- Make regular bold text a different color to make it stand out even more
    {
      intensity = "Bold",
      font = font_with_fallback("Operator Mono SSm Lig", { weight="DemiLight" }),
    },

    -- For half-intensity text, use a lighter weight font
    {
      intensity = "Half",
      font = font_with_fallback("Operator Mono SSm Lig", {weight=325}),
    },
  },

  -- Colors
  color_scheme_dirs = {"/Users/Felix/.config/wezterm/colors"},
  color_scheme = "MaterialPalenight",

  -- Appearance
  dpi = 80.0,
  enable_tab_bar = false,
  default_cursor_style = "SteadyUnderline",
  window_decoration = "NONE",
  window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 10,
  }
}
