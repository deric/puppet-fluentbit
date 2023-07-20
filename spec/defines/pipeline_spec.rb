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
        pipeline: 'input',
        plugin: 'tail',
        properties: {
          path: '/var/log/syslog',
        }
      }
    end

    it { is_expected.to compile }

    it { is_expected.to contain_concat__fragment('pipeline-input').with_content(%r{Name\s+tail\n}) }
    it { is_expected.to contain_concat__fragment('pipeline-input').with_content(%r{Path\s+/var/log/syslog\n}) }
  end
end
