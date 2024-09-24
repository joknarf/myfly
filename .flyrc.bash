echo "joknarf .flyrc.bash"
HISTCONTROL=ignorespace
HISTIGNORE="cd:cd *:history:ls:l:pwd:df:df -k:kill *:top:clear"
shopt -s histappend
PROMPT_COMMAND='history -a'
[ -f /etc/bash_completion ] && ! complete -p git >/dev/null 2>&1 && . /etc/bash_completion
[ -f /opt/homebrew/etc/bash_completion ] && . /opt/homebrew/etc/bash_completion
#bind -m vi-insert '"²": "\e"'
bind 'set enable-bracketed-paste off'
