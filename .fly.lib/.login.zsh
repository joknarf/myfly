ZDOTDIR=~/
\cd
for i in zshenv zprofile zshrc;do
    [ -r "/etc/zsh/$i" ] && "$FLY_ETC_RC" && . "/etc/zsh/$i"
    [ -r ".$i" ] && "$FLY_USER_RC" && . "./.$i"
done
unset i
#typeset +r PS1
