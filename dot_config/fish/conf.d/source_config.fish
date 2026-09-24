# adapted from
# https://github.com/fish-shell/fish-shell/issues/5707#issuecomment-467331991

function auto_source --on-event fish_prompt -d 'auto source config.fish if gets modified!'
    # $__fish_config_dir is always set by fish itself. The previous version
    # derived this from $XDG_CONFIG_HOME, which breaks when that is unset:
    # `$UNSET/fish/config.fish` expands to zero arguments, `test -f` with no
    # arguments returns true, and the path ended up empty -- leaving a bare
    # `date -r` to error on every prompt.
    set -l fish_config_file $__fish_config_dir/config.fish
    test -f $fish_config_file; or return

    set -l fish_config_time_new (date -r $fish_config_file)
    if ! set -q FISH_CONFIG_TIME
        set -g FISH_CONFIG_TIME $fish_config_time_new
    else
        if test "$FISH_CONFIG_TIME" != "$fish_config_time_new"
            set FISH_CONFIG_TIME $fish_config_time_new
            source $fish_config_file
        end
    end
end

auto_source
