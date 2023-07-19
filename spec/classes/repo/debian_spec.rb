require 'spec_helper'

describe 'fluentbit::repo::debian' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      case os_facts[:os]['family']
      when 'Debian'
        let(:facts) { os_facts }

        let(:params) do
          {
            key_location: 'https://packages.fluentbit.io/fluentbit.key',
            key_fingerprint: 'C3C0A28534B9293EAF51FABD9F9DDC083888C1CD',
          }
        end

        it { is_expected.to contain_class('apt') }

        it {
          is_expected.to contain_apt__source('fluentbit').with(
            location: "https://packages.fluentbit.io/#{os_facts[:os]['distro']['id'].downcase}/#{os_facts[:os]['distro']['codename']}",
            release: os_facts[:os]['distro']['codename'],
          )
        }
      end
    end
  end
end
