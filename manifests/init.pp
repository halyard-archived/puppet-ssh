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
  $keypath = "/Users/${::boxen_user}/.ssh/id_ed25519"
) {
  package { $package:
    require => Class['::packages']
  } ->
  exec { 'remove stale SSH key':
    command => "rm -f ${keypath}.pub",
    unless  => ["test -e ${keypath}", 'ssh-add -l | grep ED25519']
  } ->
  ssh_key { $::luser:
    require => Package['gnupg-halyard']
  } ->
  github_ssh_key { "${keypath}.pub": } ->
  exec { "ssh-add ${keypath}":
    unless   => 'ssh-add -l | grep ED25519',
    provider => 'shell',
    user     => $::boxen_user
  } ->
  file { $keypath:
    ensure => absent
  }
}
