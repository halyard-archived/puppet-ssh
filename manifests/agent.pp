class ssh::agent (
  $command = "${boxen::config::homebrewdir}/bin/ssh-agent",
  $plist = "/System/Library/LaunchAgents/org.openbsd.ssh-agent.plist"
) {
  $base_plist = basename($plist)
  $service = regsubst($base_plist, '\.plist$', '')

  file { $plist:
    ensure  => 'present',
    content => template('ssh/org.openbsd.ssh-agent.plist.erb'),
  } ~>
  exec { 'stop ssh-agent':
    command     => "launchctl stop $service",
    refreshonly => true
  } ~>
  exec { 'unload ssh-agent':
    command     => "launchctl unload $plist",
    refreshonly => true
  } ~>
  exec { 'load ssh-agent':
    command     => "launchctl load $plist",
    refreshonly => true
  } ~>
  exec { 'reload ssh-agent env':
    command     => "launchctl getenv SSH_AUTH_SOCK",
    refreshonly => true
  }
}
