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
end
