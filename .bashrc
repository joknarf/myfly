#echo "joknarf .flyrc.bash"
shopt -s histappend

histappend() {
    history 1|awk 'END{exit(NR!=1)}' && history -a && history -n
    printf '\e[?1h' >&2 #Moba shift arrow
}

PROMPT_COMMAND="histappend"
unset VSCODE_SHELL_INTEGRATION

[ "$BASH_COMPLETION$BASH_COMPLETION_COMPAT_DIR$BASH_COMPLETION_VERSION_INFO" ] || {
  [ -f /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion
  [ -f /opt/homebrew/etc/bash_completion ] && . /opt/homebrew/etc/bash_completion
}

bind 'set enable-bracketed-paste off'
unset -f command_not_found_handle
shopt -s -o history
