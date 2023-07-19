# frozen_string_literal: true

require 'spec_helper'

describe 'fluentbit' do
  _, os_facts = on_supported_os.first

  context 'with default parameters' do
    let(:facts) { os_facts }

    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_class('fluentbit') }
    it { is_expected.to contain_class('fluentbit::repo') }

    it { is_expected.to contain_package('fluent-bit').with_ensure(%r{present|installed}) }

    it {
      is_expected.to contain_service('fluentbit').with_ensure('running')
    }
  end
end
