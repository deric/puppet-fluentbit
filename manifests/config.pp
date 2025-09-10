# @summary configures the main fluentbit main config
#
# @param config_dir
#   Absolute path to main configuration directory
# @param pipelines_path
# @param scripts_path
#
# @private
#   include fluentbit::config
class fluentbit::config (
  Stdlib::Absolutepath $config_dir = $fluentbit::config_dir,
  Stdlib::Absolutepath $pipelines_path = $fluentbit::pipelines_path,
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
    -> file { $pipelines_path:
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

    if $fluentbit::format == 'classic' {
      Concat {
        ensure         => present,
        mode           => $fluentbit::config_file_mode,
        require        => File[$config_dir],
        ensure_newline => true,
      }

      concat {
        [
          "${pipelines_path}/inputs.conf",
          "${pipelines_path}/outputs.conf",
          "${pipelines_path}/filters.conf",
        ]:
      }

      concat::fragment { 'inputs-header':
        target  => "${pipelines_path}/inputs.conf",
        content => "# Managed by Puppet\n",
        order   => '01',
      }
      concat::fragment { 'outputs-header':
        target  => "${pipelines_path}/outputs.conf",
        content => "# Managed by Puppet\n",
        order   => '01',
      }
      concat::fragment { 'filters-header':
        target  => "${pipelines_path}/filters.conf",
        content => "# Managed by Puppet\n",
        order   => '01',
      }
    }

    $yaml_includes = [
      $fluentbit::parsers_path,
      $fluentbit::plugins_path,
      $fluentbit::streams_path,
      "${fluentbit::pipelines_path}/*.yaml",
    ] + $fluentbit::includes
  } else {
    $yaml_includes = [
      $fluentbit::parsers_path,
      $fluentbit::plugins_path,
      $fluentbit::streams_path,
    ] + $fluenbit::includes
  }

  $classic_includes = {
    parsers_file => "${fluentbit::parsers_file}.conf",
    plugins_file => "${fluentbit::plugins_file}.conf",
    streams_file => "${fluentbit::streams_file}.conf",
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

  $variables = $fluentbit::variables.filter |$k, $v| {
    length($v) > 0
  }

  $storage_config = $fluentbit::storage_path ? {
    undef            => {},
    default          => {
      'storage.path'                        => $fluentbit::storage_path,
      'storage.sync'                        => $fluentbit::storage_sync,
      'storage.checksum'                    => bool2str($fluentbit::storage_checksum, 'On', 'Off'),
      'storage.max_chunks_up'               => $fluentbit::storage_max_chunks_up,
      'storage.backlog.mem_limit'           => $fluentbit::storage_backlog_mem_limit,
      'storage.metrics'                     => bool2str($fluentbit::storage_metrics, 'On', 'Off'),
      'storage.delete_irrecoverable_chunks' => bool2str($fluentbit::storage_delete_irrecoverable_chunks, 'On', 'Off'),
    },
  }
  $health_config = $fluentbit::health_check ? {
    undef           => {},
    default         => {
      'health.check'                        => bool2str($fluentbit::health_check, 'On', 'Off'),
      'hc.errors_count'                     => $fluentbit::hc_errors_count,
      'hc.retry_failure_count'              => $fluentbit::hc_retry_failure_count,
      'hc.period'                           => $fluentbit::hc_period,
    },
  }
  $log_file_config = $fluentbit::log_file ? {
    undef           => {},
    default         => { 
      'log_file'                            => $fluentbit::log_file 
    },
  }

  $service_config = {
    'flush'                    => $fluentbit::flush,
    'grace'                    => $fluentbit::grace,
    'daemon'                   => bool2str($fluentbit::daemon, 'On', 'Off'),
    'dns.mode'                 => $fluentbit::dns_mode,
    'log_level'                => $fluentbit::log_level,
    'http_server'              => bool2str($fluentbit::http_server, 'On', 'Off'),
    'http_listen'              => $fluentbit::http_listen,
    'http_port'                => $fluentbit::http_port,
    'coro_stack_size'          => $fluentbit::coro_stack_size,
    'scheduler.cap'            => $fluentbit::scheduler_cap,
    'scheduler.base'           => $fluentbit::scheduler_base,
    'json.convert_nan_to_null' => $fluentbit::json_convert_nan_to_null,
  } + $storage_config + $health_config + $log_file_config

  if $fluentbit::format == 'classic' {
    $config_content = epp('fluentbit/fluentbit.conf.epp',
      {
        manage_config_dir => $fluentbit::manage_config_dir,
        variables         => $variables,
        service           => $service_config + $classic_includes,
        additional_conf   => $fluentbit::service,
      },
    )

    $parsers_content = epp('fluentbit/parsers.conf.epp',
      {
        parsers           => $fluentbit::parsers,
        multiline_parsers => $fluentbit::multiline_parsers,
      }
    )

    $plugins_content = epp('fluentbit/plugins.conf.epp', { plugins => $fluentbit::plugins })
    $streams_content = epp('fluentbit/streams.conf.epp', { streams => $fluentbit::streams })
  } elsif $fluentbit::format == 'yaml' {
    $config_content = stdlib::to_yaml(
      {
        env      => $variables,
        service  => $service_config + $fluentbit::service,
        includes => $yaml_includes,
      },
    )

    $parsers_content = stdlib::to_yaml(
      {
        parsers           => $fluentbit::parsers.map |$k, $v| {
          { name => $k } + $v
        },
        multiline_parsers => $fluentbit::multiline_parsers.map |$k, $v| {
          { name => $k } + $v
        },
      },
    )

    $plugins_content = stdlib::to_yaml({ plugins => $fluentbit::plugins })
    $streams_content = stdlib::to_yaml({ streams => $fluentbit::streams })
  } else {
    fail('Welp, something fucked up')
  }

  file { $fluentbit::config_path:
    mode    => $fluentbit::config_file_mode,
    content => $config_content,
  }

  if $fluentbit::manage_parsers_file {
    file { $fluentbit::parsers_path:
      content => $parsers_content,
    }
  }

  if $fluentbit::manage_plugins_file {
    file { $fluentbit::plugins_path:
      content => $plugins_content,
    }
  }

  if $fluentbit::manage_streams_file {
    file { $fluentbit::streams_path:
      content => $streams_content,
    }
  }
}
