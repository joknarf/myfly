echo "joknarf .flyrc.zsh" >&2
skip_global_compinit=1
autoload -Uz compinit
compinit

# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=20000
SAVEHIST=10000
setopt appendhistory
# bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
#zstyle :compinstall filename '/home/joknarf/.zshrc'

#setopt share_history
setopt incappendhistory
[ -f /opt/homebrew/etc/bash_completion ] && . /opt/homebrew/etc/bash_completion
[ -d /opt/homebrew ] && {
    export HOMEBREW_PREFIX="/opt/homebrew";
    export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
    export HOMEBREW_REPOSITORY="/opt/homebrew";
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
    export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
    export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
}
