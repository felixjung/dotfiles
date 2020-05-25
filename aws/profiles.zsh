function aaws {
  aws-vault exec --assume-role-ttl=1h -- $@
}
