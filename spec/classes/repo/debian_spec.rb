require 'spec_helper'

describe 'fluentbit::repo::debian' do
  on_supported_os.each do |os, os_facts|

    case os_facts[:os]['family']
      when 'Debian'
        context "on #{os}" do
          let(:facts) { os_facts }

          let(:params) do
            {
              key_location: 'https://packages.fluentbit.io/fluentbit.key',
              key_fingerprint: 'C3C0A28534B9293EAF51FABD9F9DDC083888C1CD',
            }
          end

          it { is_expected.to compile }

        end
      end
  end
end
