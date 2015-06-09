require 'puppet/util/errors'
require 'puppet/util/execution'

Puppet::Type.type(:ssh_key).provide :openssh do
  include Puppet::Util::Execution
  include Puppet::Util::Errors

  def exists?
    File.exists? path
  end

  def destroy
    File.unlink path
  end

  def create
    execute(keygen_command, failonfail: true, uid: @resource[:name])
  end

  private

  def keygen_command
    args = [
      'ssh-keygen',
      '-f', path,
      '-N', passphrase,
      '-C', @resource[:comment],
      '-t', @resource[:type]
    ]
    args += ['-b', @resource[:size]] if @resource[:size]
    args
  end
    
  def path
    @path ||= @resource[:path] || default_path
  end

  def default_path
    File.expand_path "~#{@resource[:name]}/.ssh/id_#{@resource[:type]}"
  end

  def passphrase
    @passphrase ||= @resource[:passphrase] || prompt_for_passphrase
  end

  def prompt_message
    "Enter SSH key passphrase for #{@resource[:name]}"
  end

  def prompt_command
    [ 
      'text returned of (display dialog',
      %W{"#{prompt_message}"},
      'with title "SSH Key"',
      'with icon caution',
      'default answer ""',
      'buttons {"Cancel", "OK"} default button 2',
      'with hidden answer)',
    ]
  end

  def prompt_for_passphrase
    result = `/usr/bin/osascript -e '#{prompt_command.join(' ')}'`.chomp
    fail('Passphrase not provided for SSH key') if result.empty?
    result
  end
end
