#echo "joknarf .flyrc.bash"
stty -ixon
export BASH_LOADABLES_PATH=/usr/lib/bash
for i in sleep id uname rm rmdir push mktemp mkdir mkfifo stat tee ln dirname basename head;do
   [ -f /usr/lib/bash/$i ] && enable -f /usr/lib/bash/$i $i
done
shopt -s histappend lithist
HISTTIMEFORMAT='%Y-%m-%d %H:%M:%S '
alias forceappkey='printf "\e[?1h" >&2' # Force arrow App Key (Moba bug)
histappend() {
   history -a;
   [[ $(history 1) = *$'\n'* ]] && history -r || history -n
   forceappkey
}
((BASH_VERSINFO[0]<5)) && histappend() {
   unset HISTTIMEFORMAT
   [[ $(history 1) = *$'\n'* ]] && history -a /dev/null && return
   history -a; history -n
   forceappkey
}
unalias resize 2>/dev/null
type -p resize >/dev/null 2>&1 || resize() {
  typeset oldstty rows cols
  oldstty=$(stty -g)
  stty raw -echo min 0 time 5
  printf '\033[18t' > /dev/tty
  IFS=';' read -r -d t _ rows cols < /dev/tty
  stty "$oldstty"
  if [[ $rows =~ ^[0-9]+$ && $cols =~ ^[0-9]+$ ]]; then
    printf 'stty rows "%s" cols "%s"' "$rows" "$cols"
  fi
}

PROMPT_COMMAND="histappend"
[ "$RBS" ] && PROMPT_COMMAND+=";. <(resize 2>/dev/null)" && sleep 1
unset VSCODE_SHELL_INTEGRATION

[ "$BASH_COMPLETION$BASH_COMPLETION_COMPAT_DIR$BASH_COMPLETION_VERSION_INFO" ] || {
  [ -f /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion
  [ -f /opt/homebrew/etc/bash_completion ] && . /opt/homebrew/etc/bash_completion
  [ -f /usr/local/share/bash-completion/bash_completion.sh ] && . /usr/local/share/bash-completion/bash_completion.sh
}

bind 'set enable-bracketed-paste off'
unset -f command_not_found_handle
#shopt -s -o history
complete -F _flyto to
touch ~/.bash_history 2>/dev/null || HISTFILE=/tmp/.bash_history.$USER
[ -f ~/.fly.psredraw ] && psredraw=~/.fly.psredraw || psredraw=$FLY_HOME/.fly.psredraw
[ -f "$psredraw" ] || cp $FLY_HOME/.fly.d/lib/psredraw.so "$psredraw"
((${BASH_VERSINFO[0]}>3)) && enable -f "$psredraw" psredraw >/dev/null 2>&1 && trap 'psredraw redraw' WINCH
unset psredraw
:

