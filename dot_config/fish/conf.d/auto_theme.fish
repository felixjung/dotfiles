function update_theme --on-variable macos_theme
    if [ "$macos_theme" = dark ]
        fish_config theme choose "TokyoNight Storm"
        set -Ux BAT_THEME tokyonight_storm
        set -xU FZF_DEFAULT_OPTS_FILE "$XDG_CONFIG_HOME/fzf/fzfrc_dark"
    else if [ "$macos_theme" = light ]
        fish_config theme choose "TokyoNight Day"
        set -Ux BAT_THEME tokyonight_day
        set -xU FZF_DEFAULT_OPTS_FILE "$XDG_CONFIG_HOME/fzf/fzfrc_light"
    end
end
