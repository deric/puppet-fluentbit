# @summary configures the main fluentbit main config
#
# @param config_dir
#   Absolute path to main configuration directory
# @param plugins_path
# @param scripts_path
#
# @private
#   include fluentbit::config
class fluentbit::config (
  Stdlib::Absolutepath $config_dir = $fluentbit::config_dir,
  Stdlib::Absolutepath $plugins_path = $fluentbit::plugins_path,
  Stdlib::Absolutepath $scripts_path = $fluentbit::scripts_path,
) {
  assert_private()

  File {
    ensure  => file,
    mode    => $fluentbit::config_file_mode,
  }

  if $fluentbit::manage_config_dir {
    file { $config_dir:
      ensure  => directory,
      purge   => true,
      recurse => true,
      mode    => $fluentbit::config_folder_mode,
    }
    -> file { $plugins_path:
      ensure  => directory,
      purge   => true,
      recurse => true,
      mode    => $fluentbit::config_folder_mode,
    }
    file { $scripts_path:
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
        "${plugins_path}/inputs.conf",
        "${plugins_path}/outputs.conf",
        "${plugins_path}/filters.conf",
      ]:
    }

    concat::fragment { 'inputs-header':
      target  => "${plugins_path}/inputs.conf",
      content => "# Managed by Puppet\n",
      order   => '01',
    }
    concat::fragment { 'outputs-header':
      target  => "${plugins_path}/outputs.conf",
      content => "# Managed by Puppet\n",
      order   => '01',
    }
    concat::fragment { 'filters-header':
      target  => "${plugins_path}/filters.conf",
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
  $health_check = bool2str($fluentbit::health_check, 'On', 'Off')
  $hc_errors_count = $fluentbit::hc_errors_count
  $hc_retry_failure_count = $fluentbit::hc_retry_failure_count
  $hc_period = $fluentbit::hc_period
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
  $health_config = $health_check ? {
    undef           => {},
    default         => {
      'health.check'                        => $health_check,
      'hc.errors_count'                     => $hc_errors_count,
      'hc.retry_failure_count'              => $hc_retry_failure_count,
      'hc.period'                           => $hc_period,
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
        } + $storage_config
          + $health_config,
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
