_pgtree()
{
   local word="${COMP_WORDS[COMP_CWORD]}" pgopt='-l' i q reply p n=$'\n' IFS="$IFS"
   case "${COMP_WORDS[COMP_CWORD-1]}" in
     -u) COMPREPLY=($(compgen -u -- "${COMP_WORDS[$COMP_CWORD]}"));return 0;;
     -t)
       IFS=$'\n';set -f
       COMPREPLY=( $(who |awk '{ printf("%s\t%-10s %s %s %s\n", $2,$1,$3,$4,$5) }') )
       set +f;return 0
     ;;
     -O) 
        local pso=(stime lstart %cpu %mem rss vsz tty exe state uid sid time wchan)
        [[ "$word" = *,* ]] && p="${word%,*},"
        pso=("${pso[@]/#/$p}")
        COMPREPLY=( $(compgen -W "${pso[*]}" -- $word) )
        return 0
     ;;
   esac
   for ((i=1;i<COMP_CWORD;i++));do
     case "${COMP_WORDS[i]}" in
       -[uUtgG]) pgopt+=" ${COMP_WORDS[i]} ${COMP_WORDS[i+1]}";;
       -f) pgopt="${pgopt/-l/-af}";;
       -t) pgopt+=" -t ${COMP_WORDS[i+1]}";;
     esac
   done
   [[ ${COMP_WORDS[*]} = *\ -f* ]] && pgopt='-af' && q="'"
   : ${word:=.}
   case "$word" in
     -*) reply="$(pgtree -h |awk -F ' : ' '$1 ~ /^ *-/{sub("^ *","");opt=$1;sub(" .*","",opt);print opt"\t"substr($0,length($1)+4)}')";;
     *) reply="$(pgrep $pgopt "$word" |awk '{print q substr($0,length($1)+2) q}' q="$q")" ;; 
   esac
   IFS=$'\n'
   set -f
   COMPREPLY=( $reply )
   set +f
   return 0
}
complete -F _pgtree pgtree pgt
