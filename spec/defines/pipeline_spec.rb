# frozen_string_literal: true

require 'spec_helper'

describe 'fluentbit::pipeline' do
  _, os_facts = on_supported_os.first
  let(:facts) { os_facts }

  context 'input plugin in classic format' do
    let(:pre_condition) { "class { 'fluentbit': format => 'classic' }" }
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
    it { is_expected.to contain_concat__fragment('pipeline-input').with_content(%r{path\s+/var/log/syslog\n}) }
  end

  context 'input plugin in yaml format' do
    let(:pre_condition) { "class { 'fluentbit': format => 'yaml' }" }
    let(:title) { 'tail' }
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

    it {
      is_expected.to contain_file('/etc/fluent-bit/pipelines/input-tail.yaml')
        .with_content(<<~YAML # rubocop:disable Style/TrailingCommaInArguments
                        ---
                        pipeline:
                          inputs:
                          - name: tail
                            alias: tail
                            db: "/opt/fluent-bit/db/tail"
                            path: "/var/log/syslog"
                      YAML
                     )
    }
  end
end
