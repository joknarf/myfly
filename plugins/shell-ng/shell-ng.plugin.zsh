[ -t 1 ] || return 0
_path_script="$(\cd "${0%/*}";pwd)"
. $_path_script/lib/nerdp
. $_path_script/lib/selector
. $_path_script/lib/redo
. $_path_script/lib/seedee
. $_path_script/lib/complete-ng.zsh
_pgt() { pgtree -M1f "$@"; }
zle -N _pgt
: "${PGT_BIND:=\C-p}"
bindkey "$PGT_BIND" _pgt
unset _path_script
