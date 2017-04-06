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
  $package = 'openssh',
  $tap = undef,
  $keypath = "/Users/${::user}/.ssh/id_ed25519"
) {

  if $tap {
    $package_fullname = "${tap}/${package}"
    $tap_require = Homebrew::Tap[$tap]
  } else {
    $package_fullname = $package
    $tap_require = []
  }

  package { $package_fullname:
    require => $tap_require
  }
  -> exec { 'remove stale SSH key':
    command => "rm -f ${keypath}.pub",
    unless  => ["test -e ${keypath}", 'ssh-add -l | grep ED25519']
  }
  -> ssh_key { $::luser:
    require => Class['::gpg']
  }
  -> github_ssh_key { "${keypath}.pub": }
  -> exec { "ssh-add ${keypath}":
    unless   => 'ssh-add -l | grep ED25519',
    provider => 'shell',
    user     => $::user
  }
  -> file { $keypath:
    ensure => absent
  }
}
