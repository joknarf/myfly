if test (count $argv) -gt 0 -a "$argv[1]" != source
    set -e _fly_loaded
end
if not set -q _fly_loaded

not set -q FLY_MSG && set -x FLY_MSG "Bzzz Bzzz !!!"
echo $FLY_MSG >&2
set -x _fly_loaded 1

not set -q FLY_HOME && set -x FLY_HOME $HOME
not set -q FLY_RC && set -x FLY_RC "$HOME/.flyrc"
not set -q FLY_TMPDIR && set -x FLY_TMPDIR /tmp
not set -q _fly_uuid && set -x _fly_uuid (cat "$FLY_HOME/.fly.d/.flyuuid" 2>/dev/null; or uuidgen)
set -x _fly_lib $FLY_HOME/.fly.d/.fly.lib
set -x FLY_SHELL fish 
set -x _fly_fish true

test -n "$_fly_lock" && trap 'flock -u 4 2>/dev/null' TERM

switch "$argv[1]"
    case source activate
        source $_fly_lib/.source_plugins.fish
    case login
        . $_fly_lib/.login.fish
        . $_fly_lib/.source_plugins.fish
end
test -n "$_fly_lock" && trap - TERM && flock -u 4 2>/dev/null #fish cannot close fd...
set -e _fly_lock
test -n "$_fly_share" && trap "flock -n 5 && flock '$_fly_share/.fly.lock' rm -rf '$_fly_share'/.fly.* && rmdir '$_fly_share' 2>/dev/null" EXIT
set -e _fly_share

function fly
   FLY_HOME="$FLY_HOME" bash -c 'args=("$@");. $FLY_HOME/.fly.d/fly "${args[@]}"' _ $argv
end

function _fly
   FLY_HOME="$FLY_HOME" bash -c 'args=("$@");. $FLY_HOME/.fly.d/fly;_fly "${args[@]}"' _ $argv
end

alias fly.fish='. $FLY_HOME/.fly.d/fly.fish'

. $_fly_lib/aliases
end # fish cannot return...
