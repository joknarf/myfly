set -l _fly_p ''
if test (count $argv) -gt 0
    set _fly_p "/$argv[1]"
end
set -l _fly_shell (string replace -r '^.*/' '' $FLY_SHELL)
set -e argv
test -r "$FLY_HOME/.fly.d/.$_fly_shell"rc && source "$FLY_HOME/.fly.d/.$_fly_shell"rc
if test -n "$_fly_p"
    for _fly_plugin in $FLY_HOME/.fly.d/plugins$_fly_p/conf.d/*.$_fly_shell
        set _fly_pdir (dirname (dirname $_fly_plugin))
        if test -r "$_fly_plugin"
            test -d "$_fly_pdir/functions"; and set -a fish_function_path "$_fly_pdir/functions"
            test -d "$_fly_pdir/completions"; and set -a fish_complete_path "$_fly_pdir/completions"
            source "$_fly_plugin"
        end
    end
else
    for _fly_plugin in $FLY_HOME/.fly.d/plugins.d/*/conf.d/*.$_fly_shell
        set _fly_pdir (dirname (dirname $_fly_plugin))
        if test -r "$_fly_plugin"
            test -d "$_fly_pdir/functions"; and set -a fish_function_path "$_fly_pdir/functions"
            test -d "$_fly_pdir/completions"; and set -a fish_complete_path "$_fly_pdir/completions"
            source "$_fly_plugin"
        end
    end
end
set -e _fly_p _fly_plugin _fly_shell _fly_pdir
