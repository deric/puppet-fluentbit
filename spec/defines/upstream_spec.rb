# frozen_string_literal: true

require 'spec_helper'

describe 'fluentbit::upstream' do
  _, os_facts = on_supported_os.first
  let(:facts) { os_facts }
  let(:pre_condition) { 'include fluentbit' }

  context 'create upstreams' do
    let(:title) { 'upstreams' }
    let(:params) do
      {
        nodes: {
          'n1' => { 'host' => '127.0.0.1', 'port' => 1234 },
          'n2' => { 'host' => '127.0.0.1', 'port' => 1235 },
        },
      }
    end

    it { is_expected.to compile }
  end
end
