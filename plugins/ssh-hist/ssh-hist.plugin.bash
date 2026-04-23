: "${SSH_HIST:=$HOME/.ssh_hist}"
_ssh_hist()
{
  typeset e host
  \ssh "$@" ;e=$?
  [ "$e" != 255 ] && {
    read -r _ host <<<$(\ssh -G "$@")
    [ "$host" ] || return $e
    printf '%s\n' "$host" >"$SSH_HIST.tmp"
    [ -w "$SSH_HIST" ] && grep -Fxv "$host" "$SSH_HIST" >>"$SSH_HIST.tmp"
    [ -s "$SSH_HIST.tmp" ] && mv "$SSH_HIST.tmp" "$SSH_HIST"
  }
  return $e
}

_known_hosts_real()
{
  typeset word="${COMP_WORDS[$COMP_CWORD]}" col 
  COMP_SORT=''
  COMPREPLY=( $([ "$word" ] && grep -F "$word" "$SSH_HIST" || cat "$SSH_HIST") )
}

alias ssh=_ssh_hist
