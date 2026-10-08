_pgtree()
{
   local word="${COMP_WORDS[COMP_CWORD]:-.}" pgopt='-l' q reply p n=$'\n'
   [[ ${COMP_WORDS[*]} = *\ -f* ]] && pgopt='-af' && q="'"
   case "$word" in
     -*) reply="$(pgtree -h |awk -F ' : ' '$1 ~ /^ *-/{sub("^ *","");opt=$1;sub(" .*","",opt);print opt"\t"substr($0,length($1)+4)}')";;
     *) if [ "${COMP_WORDS[COMP_CWORD-1]}" = -O ];then
          pso=(lstart %cpu %mem rss tty exe state time wchan)
          [[ "$word" = *,* ]] && p="${word%,*}," && word=${word##*,} && : ${word:=.}
          pso=("${pso[@]/#/$p}")
          reply=$(\grep "^$word" < <(IFS=$'\n';echo "${pso[*]}"))
        else
          reply="$(pgrep $pgopt "$word" |awk '{print q substr($0,length($1)+2) q}' q="$q")"
        fi
        ;;
   esac
   local IFS=$'\n'
   set -f
   COMPREPLY=($(printf %s "$reply"))
   set +f
   return 0
}
complete -F _pgtree pgtree pgt
