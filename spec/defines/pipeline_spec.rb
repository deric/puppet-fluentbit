# frozen_string_literal: true

require 'spec_helper'

describe 'fluentbit::pipeline' do
  _, os_facts = on_supported_os.first
  let(:facts) { os_facts }
  let(:pre_condition) { 'include fluentbit' }

  context 'input plugin' do
    let(:title) { 'input' }
    let(:params) do
      {
        type: 'input',
        plugin_name: 'dummy',

      }
    end

    it { is_expected.to compile }
  end
end
