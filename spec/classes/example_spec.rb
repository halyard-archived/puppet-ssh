require 'spec_helper'

describe 'ssh' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "ssh class without any parameters" do
          let(:params) {{ }}

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('ssh::params') }
          it { is_expected.to contain_class('ssh::install').that_comes_before('ssh::config') }
          it { is_expected.to contain_class('ssh::config') }
          it { is_expected.to contain_class('ssh::service').that_subscribes_to('ssh::config') }

          it { is_expected.to contain_service('ssh') }
          it { is_expected.to contain_package('ssh').with_ensure('present') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'ssh class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { is_expected.to contain_package('ssh') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
