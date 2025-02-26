# @summary Configures fluentbit using YAML config
#
# @param config_dir
#   Absolute path to main configuration directory
# @param plugins_path
# @param scripts_path
#
# @private
class fluentbit::config_yaml (
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
  }

  $config_hash = {
    'env' => $fluentbit::variables,
    'service' => {
      'flush' => $fluentbit::flush,
      'log_level' => $fluentbit::log_level,
      'http_server' => bool2str($fluentbit::http_server, 'on', 'off'),
    },
    'pipeline' => {
      'inputs' => $fluentbit::inputs,
      'outputs' => $fluentbit::outputs,
      'filters' => $fluentbit::filters,
    },
  } + $fluentbit::yaml

  file { $fluentbit::config_path:
    mode    => $fluentbit::config_file_mode,
    content => stdlib::to_yaml($config_hash),
  }
}
