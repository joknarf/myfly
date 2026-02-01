#echo "joknarf .flyrc.zsh" >&2
skip_global_compinit=1
autoload -Uz compinit
compinit

HISTFILE=~/.zsh_history
HISTSIZE=20000
SAVEHIST=10000
setopt appendhistory
fc -R

#setopt share_history
setopt incappendhistory
