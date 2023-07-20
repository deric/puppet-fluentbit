require 'spec_helper'

describe 'fluentbit::repo::redhat' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      case os_facts[:os]['family']
      when 'RedHat'
        let(:facts) { os_facts }

        version = os_facts[:os]['release']['major']

        it {
          is_expected.to contain_yumrepo('fluent-bit').with(
            'baseurl' => "https://packages.fluentbit.io/centos/#{version}/",
            'gpgkey'  => 'https://packages.fluentbit.io/fluentbit.key',
            'enabled' => '1',
            'gpgcheck' => '1',
          )
        }
      end
    end
  end
end
