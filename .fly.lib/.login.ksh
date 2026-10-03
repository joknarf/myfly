typeset +x ENV
ENV=~/.kshrc
#alias typeset="typeset +r"
#alias readonly=typeset
alias _src_etc_profile_d='true' # rhel
((FLY_ETC_RC)) && . /etc/profile
\cd
((FLY_USER_RC)) && {
  [ -r .profile ] && . ./.profile
  [ -r "$ENV" ] && . "$ENV"
}
#unalias typeset readonly
unalias _src_etc_profile_d
