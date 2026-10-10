_pgt_reply() {
  local IFS=$'\n'
  set -f
  COMPREPLY=( $(cat $1) )
  set +f
}
_pgtree()
{
   local word="${COMP_WORDS[COMP_CWORD]}" pgopt='-l' i q reply p n=$'\n' IFS="$IFS"
   for ((i=1;i<COMP_CWORD;i++));do
     case "${COMP_WORDS[i]}" in
       -[uUtgG]) ((i<COMP_CWORD-1)) && pgopt+=" ${COMP_WORDS[i]} ${COMP_WORDS[i+1]}";;
       -f) pgopt="${pgopt/-l/-af}";q="'";;
     esac
   done
   case "${COMP_WORDS[COMP_CWORD-1]}" in
     -u) _pgt_reply <(ps ax -o user=|sort -u);return 0;;
     -t) _pgt_reply <(who |awk '{ printf("%s\t%-10s %s %s %s\n", $2,$1,$3,$4,$5) }')
         return 0
     ;;
     -[pP]) _pgt_reply <(pgrep -a $pgopt . |awk '{print $1"\t"substr($0,length($1)+2)}')
       return 0
     ;;
     -O) 
        local pso=(stime lstart %cpu %mem rss vsz tty exe stat state uid sid time wchan)
        [[ "$word" = *,* ]] && p="${word%,*},"
        pso=("${pso[@]/#/$p}")
        COMPREPLY=( $(compgen -W "${pso[*]}" -- $word) )
        return 0
     ;;
   esac
   : ${word:=.}
   case "$word" in
     -*) reply="$(pgtree -h |awk -F ' : ' '$1 ~ /^ *-/{sub("^ *","");opt=$1;sub(" .*","",opt);print opt"\t"substr($0,length($1)+4)}')";;
     *) reply="$(pgrep $pgopt "$word" |awk '{print q substr($0,length($1)+2) q}' q="$q")" ;; 
   esac
   _pgt_reply <<<"$reply"
   return 0
}
complete -F _pgtree pgtree pgt
