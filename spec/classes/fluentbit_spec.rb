# frozen_string_literal: true

require 'spec_helper'

describe 'fluentbit' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to contain_class('fluentbit') }

      case os_facts[:os]['family']
      when 'Debian'
        it {
          is_expected.to contain_package('fluent-bit').with_ensure(%r{present|installed})
        }
      end
    end
  end
end
