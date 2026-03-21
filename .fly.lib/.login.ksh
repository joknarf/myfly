\cd /;\cd
typeset +x ENV
ENV=~/.kshrc
#alias typeset="typeset +r"
#alias readonly=typeset
alias _src_etc_profile_d='true'
$FLY_ETC_RC && . /etc/profile
[ -r .profile ] && $FLY_USER_RC && . ./.profile
[ -r "$ENV" ] && $FLY_USER_RC && . $ENV
unalias _src_etc_profile_d
#unalias typeset
#unalias readonly
