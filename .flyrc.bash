echo "joknarf .flyrc.bash"
HISTCONTROL=ignorespace
HISTIGNORE="cd:cd *:history:ls:l:pwd:df:df -k:kill *:top:clear"
shopt -s histappend
PROMPT_COMMAND='history -a'
[ -f /etc/bash_completion ] && ! complete -p git >/dev/null 2>&1 && . /etc/bash_completion
[ -f /opt/homebrew/etc/bash_completion ] && . /opt/homebrew/etc/bash_completion
bind -m vi-insert '"²": "\e"'
bind -m vi-insert '"ù": "\eA'"'"'\eI.\eI\C-xs'"'"'\C-xm\e0xi\C-xc\ei.\C-xk$(_cdpr=1 cdhist + '"'"'\C-y\C-h'"'"')\C-xe\eI\C-xx\eA\C-xr\015"'
