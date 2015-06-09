# == Class: ssh
#
# Full description of class ssh here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class ssh {
  package { 'openssh': } ->
  ssh_key { "$::luser": }
}
