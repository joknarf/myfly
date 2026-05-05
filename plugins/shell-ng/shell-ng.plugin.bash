[ -t 1 ] || return 0
_path_script="$(\cd "${BASH_SOURCE%/*}";pwd)"
. $_path_script/lib/nerdp
. $_path_script/lib/selector
. $_path_script/lib/redo
. $_path_script/lib/seedee
. $_path_script/lib/complete-ng.bash
unset _path_script
