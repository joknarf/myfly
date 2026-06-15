_flyin()
{
   case "$COMP_CWORD" in
     1) COMPREPLY=($(compgen -W "$(docker ps --format '{{.Names}}' 2>/dev/null)" -- "${COMP_WORDS[$COMP_CWORD]}"));return 0;;
     *) COMPREPLY=($(compgen -c -- "${COMP_WORDS[$COMP_CWORD]}"));return 0;;
   esac
}
complete -F _flyin flyin fin
