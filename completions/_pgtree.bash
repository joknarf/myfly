_pgtree()
{
   local word="${COMP_WORDS[COMP_CWORD]}" pgopt='-l' q reply p n=$'\n'
   case "${COMP_WORDS[COMP_CWORD-1]}" in
     -u) COMPREPLY=($(compgen -u -- "${COMP_WORDS[$COMP_CWORD]}"));return 0;;
     -O) 
        local pso=(lstart %cpu %mem rss tty exe state time wchan)
        [[ "$word" = *,* ]] && p="${word%,*},"
        pso=("${pso[@]/#/$p}")
        COMPREPLY=( $(compgen -W "${pso[*]}" -- $word) )
        return 0
     ;;
   esac
   [[ ${COMP_WORDS[*]} = *\ -f* ]] && pgopt='-af' && q="'"
   : ${word:=.}
   case "$word" in
     -*) reply="$(pgtree -h |awk -F ' : ' '$1 ~ /^ *-/{sub("^ *","");opt=$1;sub(" .*","",opt);print opt"\t"substr($0,length($1)+4)}')";;
     *) reply="$(pgrep $pgopt "$word" |awk '{print q substr($0,length($1)+2) q}' q="$q")" ;; 
   esac
   local IFS=$'\n'
   set -f
   COMPREPLY=($(printf %s "$reply"))
   set +f
   return 0
}
complete -F _pgtree pgtree pgt
