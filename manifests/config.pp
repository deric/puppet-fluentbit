# @summary configures the main fluentbit main config
#
# Includes all [input] and [output] configs. (@include)
# Sets global variables (@set)
# Configures global [service] section
#
# @private
#   include fluentbit::config
class fluentbit::config {
  assert_private()

  File {
    ensure  => file,
    mode    => $fluentbit::config_file_mode,
  }

  $config_dir = dirname($fluentbit::config_file)
  $plugin_dir = "${config_dir}/pipelines"
  $scripts_dir = "${config_dir}/lua-scripts"

  if $fluentbit::manage_config_dir {
    file { $config_dir:
      ensure  => directory,
      purge   => true,
      recurse => true,
      mode    => $fluentbit::config_folder_mode,
    }
    -> file { $plugin_dir:
      ensure  => directory,
      purge   => true,
      recurse => true,
      mode    => $fluentbit::config_folder_mode,
    }
    file { $scripts_dir:
      ensure  => directory,
      purge   => true,
      recurse => true,
      mode    => $fluentbit::config_folder_mode,
      require => File[$config_dir],
    }

    Concat {
      ensure         => present,
      mode           => $fluentbit::config_file_mode,
      require        => File[$config_dir],
      ensure_newline => true,
    }

    concat {
      [
        "${plugin_dir}/inputs.conf",
        "${plugin_dir}/outputs.conf",
        "${plugin_dir}/filters.conf",
      ]:
    }

    concat::fragment { 'inputs-header':
      target  => "${plugin_dir}/inputs.conf",
      content => "# Managed by Puppet\n",
      order   => '01',
    }
    concat::fragment { 'outputs-header':
      target  => "${plugin_dir}/outputs.conf",
      content => "# Managed by Puppet\n",
      order   => '01',
    }
    concat::fragment { 'filters-header':
      target  => "${plugin_dir}/filters.conf",
      content => "# Managed by Puppet\n",
      order   => '01',
    }
  }

  if $fluentbit::manage_data_dir {
    file { $fluentbit::data_dir:
      ensure => directory,
      mode   => $fluentbit::config_folder_mode,
    }
  }

  if $fluentbit::manage_storage_dir and $fluentbit::storage_path {
    file { $fluentbit::storage_path:
      ensure => directory,
      mode   => $fluentbit::config_folder_mode,
    }
  }

  $flush = $fluentbit::flush
  $grace = $fluentbit::grace
  $daemon = bool2str($fluentbit::daemon, 'On', 'Off')
  $dns_mode = $fluentbit::dns_mode
  $log_level = $fluentbit::log_level
  $parsers_file = $fluentbit::parsers_file
  $plugins_file = $fluentbit::plugins_file
  $streams_file = $fluentbit::streams_file
  $http_server = bool2str($fluentbit::http_server, 'On', 'Off')
  $http_listen = $fluentbit::http_listen
  $http_port = $fluentbit::http_port
  $coro_stack_size = $fluentbit::coro_stack_size
  $storage_path = $fluentbit::storage_path
  $storage_sync = $fluentbit::storage_sync
  $storage_checksum = bool2str($fluentbit::storage_checksum, 'On', 'Off')
  $storage_backlog_mem_limit = $fluentbit::storage_backlog_mem_limit
  $storage_max_chunks_up = $fluentbit::storage_max_chunks_up
  $storage_metrics = bool2str($fluentbit::storage_metrics, 'On', 'Off')
  $storage_delete_irrecoverable_chunks = bool2str($fluentbit::storage_delete_irrecoverable_chunks, 'On', 'Off')
  $scheduler_cap = $fluentbit::scheduler_cap
  $scheduler_base = $fluentbit::scheduler_base
  $json_convert_nan_to_null = $fluentbit::json_convert_nan_to_null
  $variables = $fluentbit::variables.filter |$k, $v| {
    length($v) > 0
  }

  $storage_config = $storage_path ? {
    undef            => {},
    default          => {
      'storage.path'                        => $storage_path,
      'storage.sync'                        => $storage_sync,
      'storage.checksum'                    => $storage_checksum,
      'storage.max_chunks_up'               => $storage_max_chunks_up,
      'storage.backlog.mem_limit'           => $storage_backlog_mem_limit,
      'storage.metrics'                     => $storage_metrics,
      'storage.delete_irrecoverable_chunks' => $storage_delete_irrecoverable_chunks,
    },
  }

  file { $fluentbit::config_file:
    mode    => $fluentbit::config_file_mode,
    content => epp('fluentbit/fluentbit.conf.epp',
      {
        manage_config_dir => $fluentbit::manage_config_dir,
        variables         => $variables,
        service           => {
          'flush'                    => $flush,
          'grace'                    => $grace,
          'daemon'                   => $daemon,
          'dns.mode'                 => $dns_mode,
          'log_level'                => $log_level,
          'parsers_file'             => $parsers_file,
          'plugins_file'             => $plugins_file,
          'streams_file'             => $streams_file,
          'http_server'              => $http_server,
          'http_listen'              => $http_listen,
          'http_port'                => $http_port,
          'coro_stack_size'          => $coro_stack_size,
          'scheduler.cap'            => $scheduler_cap,
          'scheduler.base'           => $scheduler_base,
          'json.convert_nan_to_null' => $json_convert_nan_to_null,
        } + $storage_config,
      },
    ),
  }

  $parsers = $fluentbit::parsers
  $multiline_parsers = $fluentbit::multiline_parsers

  file { $fluentbit::parsers_file:
    content => epp('fluentbit/parsers.conf.epp',
      {
        parsers           => $parsers,
        multiline_parsers => $multiline_parsers,
      }
    ),
  }

  file { $fluentbit::plugins_file:
    content => epp('fluentbit/plugins.conf.epp', { plugins => $fluentbit::plugins }),
  }

  file { $fluentbit::streams_file:
    content => epp('fluentbit/streams.conf.epp', { streams => $fluentbit::streams }),
  }
}
