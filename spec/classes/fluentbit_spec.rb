# frozen_string_literal: true

require 'spec_helper'

describe 'fluentbit' do
  _, os_facts = on_supported_os.first
  let(:facts) { os_facts }

  context 'with default parameters' do
    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_class('fluentbit') }
    it { is_expected.to contain_class('fluentbit::repo') }
    it { is_expected.to contain_class('fluentbit::install') }
    it { is_expected.to contain_class('fluentbit::config') }
    it { is_expected.to contain_class('fluentbit::service') }
    it { is_expected.to contain_package('fluent-bit').with_ensure(%r{present|installed}) }
    it { is_expected.to contain_service('fluentbit').with_ensure('running') }

    it { is_expected.to contain_concat('/etc/fluent-bit/pipelines/inputs.conf') }
    it { is_expected.to contain_concat('/etc/fluent-bit/pipelines/outputs.conf') }
    it { is_expected.to contain_concat('/etc/fluent-bit/pipelines/filters.conf') }

    it {
      is_expected.to contain_file('/etc/fluent-bit').with(
        ensure: 'directory',
      )
    }

    it {
      is_expected.to contain_file('/etc/fluent-bit/fluent-bit.conf').with(
        ensure: 'file',
      )
    }
  end

  context 'with custom directories' do
    let(:params) do
      {
        config_dir: '/etc/fluentbit',
        config_file: '/etc/fluentbit/fluent-bit.conf',
      }
    end

    it { is_expected.to compile.with_all_deps }

    it {
      is_expected.to contain_file('/etc/fluentbit').with(
        ensure: 'directory',
        purge: true,
        recurse: true,
      )
    }

    it {
      is_expected.to contain_file('/etc/fluentbit/pipelines').with(
        ensure: 'directory',
        purge: true,
        recurse: true,
      )
    }

    it {
      is_expected.to contain_file('/etc/fluentbit/lua-scripts').with(
        ensure: 'directory',
        purge: true,
        recurse: true,
      )
    }
  end
end
