require 'puppet/util/execution'

Puppet::Type.newtype(:github_ssh_key) do
  @doc = "Manage GitHub SSH keys"

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:path) do
    isnamevar
    desc 'Path of SSH public key'
  end

  newparam(:title) do
    desc 'Title for key on GitHub'
  end
end
