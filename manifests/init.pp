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
  $tap     = 'homebrew/dupes',
  $package = 'openssh'
) {
  if size($tap) {
    $full_package = "${tap}/${package}"
    homebrew::tap { $tap:
      before => Package[$full_package]
    }
  } else {
    $full_package = $package
  }

  package { $full_package: } ->
  ssh_key { $::luser: }

  include ssh::agent
}
