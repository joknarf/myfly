_fly_hist_array() {
    local IFS=$'\n'
    set -f; FLY_HIST=($(cat)); set +f
}
_flyto() {
    COMP_SORT=''
    COMP_DELFUNC=_fly_hist_del
    local FLY_HIST
    ((COMP_CWORD)) || return 1
    ((COMP_CWORD==1)) && _fly_hist_array <<<"$(_fly_hist "${COMP_WORDS[1]}" $'\t')"
    shift
    [ "$_compfunc_ssh" ] && $_compfunc_ssh ssh "$@" && COMPREPLY=( "${FLY_HIST[@]}" "${COMPREPLY[@]}" ) && return
    COMPREPLY=( "${FLY_HIST[@]%%$'\t'*}" )
}
declare -F _completion_loader >/dev/null && _completion_loader ssh
complete -F _flyto flyto fto fssh bto kto zto fsshb fsshk fsshz
