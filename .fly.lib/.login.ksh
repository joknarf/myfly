typeset +x ENV
ENV=~/.kshrc
#alias typeset="typeset +r"
#alias readonly=typeset
alias _src_etc_profile_d='true' # rhel
$FLY_ETC_RC && . /etc/profile
\cd
[ -r .profile ] && $FLY_USER_RC && . ./.profile
[ -r "$ENV" ] && $FLY_USER_RC && . "$ENV"
#unalias typeset readonly
unalias _src_etc_profile_d
