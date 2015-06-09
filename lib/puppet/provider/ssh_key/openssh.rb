require 'puppet/util/errors'
require 'puppet/util/execution'

Puppet::Type.type(:homebrew_repo).provide :homebrew do
  include Puppet::Util::Execution
  include Puppet::Util::Errors

  def exist?
    File.exist? path
  end

  def destroy
    File.unlink path
  end

  def create
    fail('No passphrase provided') unless @resource[:passphrase]
    execute([
      'openssh',
      '-f', path,
      '-N', @resource[:passphrase],
      '-C', @resource[:comment],
      '-t', @resource[:type],
      '-b', @resource[:size]
    ], failonfail: true)
  end

  private

  def path
    @path ||= @resource[:path] || default_path
  end

  def default_path
    File.expand_path "~#{@resource[:name]}/.ssh/id_#{@resource[:type]}"
  end
end
