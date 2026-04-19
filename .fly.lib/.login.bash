alias typeset="typeset +r"
alias readonly=typeset
shopt() { [ "$2" = login_shell ] && return 0; builtin shopt "$@"; }
typeset +x PS1
PS1='$ '
$FLY_ETC_RC && . /etc/profile
\cd
$FLY_USER_RC && for i in .bash_profile .bash_login .profile;do
    if [ -r "$i" ] ;then . "./$i"; break; fi
done
unalias typeset readonly
unset -f shopt
