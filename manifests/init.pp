# == Class: ssh
#
# Full description of class ssh here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class ssh (
  $package = 'homebrew/dupes/openssh',
) {
  package { $package:
    require => Class['::packages']
  } ->
  ssh_key { $::luser: } ~>
  github_ssh_key { '~/.ssh/id_ed25519.pub': }
}
