: "${SSH_HIST:=$HOME/.ssh_history}"

ssh()
{
  typeset e user host
  read -r host user <<<"$(command ssh -G "$@" 2>/dev/null| awk '
    $1=="host"{h=$2}
    $1=="hostname" && ! h {h=$2}
    $1=="user"{u=$2}
    h && u {exit}
    END{ if (h) print tolower(h),u }
  ')"
  [ "$host" ] && touch "$SSH_HIST" 2>/dev/null && {
    printf '%s\t%s\n' "$host" "$(date +'%Y-%m-%d %H:%M') $user $SUDO_USER" >"$SSH_HIST.tmp"
    \grep -v "^$host"$'\t' "$SSH_HIST" >>"$SSH_HIST.tmp"
    [ -s "$SSH_HIST.tmp" ] && mv "$SSH_HIST.tmp" "$SSH_HIST"
  }
  command ssh "$@"
}

_ssh_history()
{
  [ "${FUNCNAME[1]}" = _ssh ] && {
    typeset word="${COMP_WORDS[$COMP_CWORD]}" col ifs=$IFS
    [ -r "$SSH_HIST" ] || return 1
    COMP_SORT=''
    IFS=$'\n'
    COMPREPLY=( $([ "$word" ] && grep -F "$word" "$SSH_HIST" || cat "$SSH_HIST") )
    IFS="$ifs"
    [ "${#COMPREPLY[@]}" = 0 ] && return 1
    return 0
  }
  \_known_hosts_real "$@"
}

alias _known_hosts_real='_ssh_history'
declare -F _ssh >/dev/null && eval "$(declare -f _ssh)"
