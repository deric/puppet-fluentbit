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
    it { is_expected.to contain_service('fluent-bit').with_ensure('running') }

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

    it {
      is_expected.to contain_file('/etc/fluent-bit/lua-scripts').with(
        ensure: 'directory',
      )
    }

    it {
      is_expected.to contain_file('/etc/fluent-bit/pipelines').with(
        ensure: 'directory',
      )
    }

    it {
      is_expected.to contain_file('/opt/fluent-bit/db').with(
        ensure: 'directory',
      )
    }

    it {
      is_expected.to contain_file('/opt/fluent-bit/storage').with(
        ensure: 'directory',
      )
    }
  end

  context 'using yaml format' do
    let(:params) do
      {
        format: 'yaml',
      }
    end

    it { is_expected.to compile.with_all_deps }

    it { is_expected.not_to contain_concat('/etc/fluent-bit/pipelines/inputs.conf') }
    it { is_expected.not_to contain_concat('/etc/fluent-bit/pipelines/outputs.conf') }
    it { is_expected.not_to contain_concat('/etc/fluent-bit/pipelines/filters.conf') }

    it {
      is_expected.to contain_file('/etc/fluent-bit').with(
        ensure: 'directory',
      )
    }

    it {
      is_expected.not_to contain_file('/etc/fluent-bit/fluent-bit.conf').with(
        ensure: 'file',
      )
    }

    it {
      is_expected.to contain_file('/etc/fluent-bit/fluent-bit.yaml').with(
        ensure: 'file',
      )
    }
  end

  context 'with package_ensure' do
    let(:params) do
      {
        package_ensure: '3.2.9',
      }
    end

    it { is_expected.to contain_package('fluent-bit').with_ensure('3.2.9').that_notifies('Service[fluent-bit]') }
  end

  context 'with custom directories in classic format' do
    let(:params) do
      {
        format: 'classic',
        config_dir: '/etc/fluentbit',
        config_file: 'fluent-bit',
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

    it {
      is_expected.to contain_file('/etc/fluentbit/fluent-bit.conf').with(ensure: 'file')
                                                                   .with_content(%r{parsers_file\s+parsers.conf})
    }

    it {
      is_expected.to contain_file('/etc/fluentbit/fluent-bit.conf').with(ensure: 'file')
                                                                   .with_content(%r{plugins_file\s+plugins.conf})
    }

    it {
      is_expected.to contain_file('/etc/fluentbit/fluent-bit.conf').with(ensure: 'file')
                                                                   .with_content(%r{streams_file\s+streams.conf})
    }
  end

  context 'with custom directories in yaml format' do
    let(:params) do
      {
        format: 'yaml',
        config_dir: '/etc/fluentbit',
        config_file: 'fluent-bit',
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

    it {
      is_expected.to contain_file('/etc/fluentbit/fluent-bit.yaml').with(
        ensure: 'file',
      )
    }
  end

  context 'override service file in classic format' do
    let(:params) do
      {
        format: 'classic',
        service_override_unit_file: true,
      }
    end

    it {
      is_expected.to contain_file('/etc/systemd/system/fluent-bit.service').with(
        ensure: 'file',
      ).with_content(%r{ExecStart=/opt/fluent-bit/bin/fluent-bit -c /etc/fluent-bit/fluent-bit.conf --enable-hot-reload})
    }
  end

  context 'override service file in yaml format' do
    let(:params) do
      {
        format: 'yaml',
        service_override_unit_file: true,
      }
    end

    it {
      is_expected.to contain_file('/etc/systemd/system/fluent-bit.service').with(
        ensure: 'file',
      ).with_content(%r{ExecStart=/opt/fluent-bit/bin/fluent-bit -c /etc/fluent-bit/fluent-bit.yaml --enable-hot-reload})
    }
  end

  context 'configure json parser in classic format' do
    let(:params) do
      {
        format: 'classic',
        parsers: {
          'json': {
            'format': 'json',
            'time_key': 'time',
            'time_format': '%d/%b/%Y:%H:%M:%S %z',
          }
        },
      }
    end

    it {
      is_expected.to contain_file('/etc/fluent-bit/parsers.conf')
        .with_content(%r{Name\s+json\n\s+Format\s+json\n\s+Time_key\s+time})
    }
  end

  context 'configure json parser in yaml format' do
    let(:params) do
      {
        format: 'yaml',
        parsers: {
          'json': {
            'format': 'json',
            'time_key': 'time',
            'time_format': '%d/%b/%Y:%H:%M:%S %z',
          }
        },
      }
    end

    it {
      is_expected.to contain_file('/etc/fluent-bit/parsers.yaml')
        .with_content(<<~YAML # rubocop:disable Style/TrailingCommaInArguments
                      ---
                      parsers:
                      - name: json
                        format: json
                        time_key: time
                        time_format: "%d/%b/%Y:%H:%M:%S %z"
                      multiline_parsers: []
                      YAML
                     )
    }
  end

  context 'configure inputs in classic format' do
    let(:params) do
      {
        format: 'classic',
        inputs: {
          'syslog': {
            'plugin': 'tail',
            'properties': {
              'Path': '/var/log/syslog',
            }
          }
        },
      }
    end

    it {
      is_expected.to contain_concat__fragment('pipeline-syslog')
        .with_content(%r{Name\s+tail\n})
        .with_content(%r{Path\s+/var/log/syslog\n})
    }

    it {
      is_expected.to contain_fluentbit__pipeline('syslog')
        .with({
                'plugin': 'tail',
          'pipeline': 'input',
              })
    }
  end

  context 'configure inputs in yaml format' do
    let(:params) do
      {
        format: 'yaml',
        inputs: {
          'syslog': {
            'plugin': 'tail',
            'properties': {
              'path': '/var/log/syslog',
            }
          }
        },
      }
    end

    it {
      is_expected.to contain_file('/etc/fluent-bit/pipelines/input-syslog.yaml')
        .with_content(<<~YAML # rubocop:disable Style/TrailingCommaInArguments
                      ---
                      pipeline:
                        inputs:
                        - name: tail
                          alias: syslog
                          db: "/opt/fluent-bit/db/syslog"
                          path: "/var/log/syslog"
                      YAML
                     )
    }

    it {
      is_expected.to contain_fluentbit__pipeline('syslog')
        .with({
                'plugin': 'tail',
                'pipeline': 'input',
              })
    }
  end

  context 'configure outputs' do
    let(:params) do
      {
        outputs: {
          'prometheus': {
            'plugin': 'prometheus_exporter',
            'properties': {
              'match': 'nginx.metrics.*',
              'host': '0.0.0.0',
              'port': '2021',
            }
          }
        },
      }
    end

    it {
      is_expected.to contain_concat__fragment('pipeline-prometheus')
        .with_content(%r{match\s+nginx.metrics.*\n})
        .with_content(%r{host\s+0.0.0.0\n})
    }

    it {
      is_expected.to contain_fluentbit__pipeline('prometheus')
        .with({
                'plugin': 'prometheus_exporter',
          'pipeline': 'output',
              })
    }
  end

  context 'with service memory limit' do
    let(:params) do
      {
        service_override_unit_file: true,
        memory_max: '2G',
        manage_service: true,
      }
    end

    it {
      is_expected.to contain_service('fluent-bit')
        .with_ensure('running')
    }

    it {
      is_expected.to contain_systemd__unit_file('fluent-bit.service')
        .with_content(%r{MemoryMax=2G})
    }
  end

  describe 'with service config via hash' do
    context 'with classic format' do
      let(:params) do
        {
          format: 'classic',
          service: {
            'storage.pause_on_chunks_overlimit': 'on',
          },
        }
      end

      it {
        is_expected.to contain_file('/etc/fluent-bit/fluent-bit.conf')
          .with_content(%r{storage.pause_on_chunks_overlimit\s+on\n})
      }
    end

    context 'with yaml format' do
      let(:params) do
        {
          format: 'yaml',
          service: {
            'storage.pause_on_chunks_overlimit': 'on',
          },
        }
      end

      it {
        is_expected.to contain_file('/etc/fluent-bit/fluent-bit.yaml')
          .with_content(%r{storage.pause_on_chunks_overlimit: 'on'\n})
      }
    end
  end
end
