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
  ssh_key { $::luser:
    require => Package['gnupg-halyard']
  } ->
  github_ssh_key { '~/.ssh/id_ed25519.pub': } ->
  exec { 'ssh-add ~/.ssh/id_ed25519':
    unless   => 'ssh-add ~/.ssh/id_ed25519 | grep ED25519',
    provider => 'shell',
    uid      => $::boxen_user
  } ~>
  exec { 'rm ~/.ssh/id_ed25519':
    refreshonly => true
  }
}
