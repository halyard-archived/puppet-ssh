Puppet::Type.newtype(:osx_login_item) do
  @doc = "Manage SSH keys"

  ensurable

  newparam :name do
    desc 'User to manage SSH key for'

    validate do |v|
      unless system('id', v) == 0
        raise ArgumentError, 'User is not valid'
      end
    end
  end

  newparam :type do
    desc 'Kind of key to create'
    newvalues(:rsa, :ecdsa, :ed25519)
    defaultto :ed25519
  end

  newparam :size do
    desc 'Size of key to create'
    defaultto nil

    validate do |v|
      return super if v.nil?
      case resource[:type]
      when :ecdsa
        unless [256, 384, 521].include? v
          raise(ArgumentError, 'Invalid size given for ecdsa')
        end
      when :rsa
        unless v.is_a?(Integer) && v > 2047
          raise(ArgumentError, 'Size must be an integer greater than 2047')
        end
      end
    end

    munge do |v|
      return super unless v.nil?
      case resource[:type]
      when :ecdsa
        521
      when :rsa
        4096
      else
        nil
      end
    end

    newparam :comment do
      desc 'Comment for SSH key'
      defaultto do
        host = Facter.value(:'hostname::hostname') || Facter.value(:hostname)
        "#{Facter.value(:luser)}@#{host}"
      end
    end

    newparam :path do
      desc 'File path for key'
    end

    newparam :passphrase do
      desc 'Passphrase for key'
      defaultto do
        Facter.value(:ssh_passphrase)
      end
    end
  end
end
