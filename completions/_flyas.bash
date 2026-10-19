_flyas()
{
   case "$COMP_CWORD" in
     1) COMPREPLY=($(compgen -u -- "${COMP_WORDS[$COMP_CWORD]}"));return 0;;
     *) COMPREPLY=($(compgen -c -- "${COMP_WORDS[$COMP_CWORD]}"));return 0;;
   esac
}
complete -F _flyas flyas fsu bsu zsu ksu flyas fsudo fsub fsuz fsuk fsuf
