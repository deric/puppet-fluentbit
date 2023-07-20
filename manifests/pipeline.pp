# @summary Configures fluentbit pipeline (input, output or filter)
#
# @note This resource add extra configuration elements for some combinations of
#  type-plugin_names, like db configuration for input plugins, or upstream configuration
#  for output-forward plugin
#
# @example
#   fluentbit::pipeline { 'input-dummy':
#     type        => 'input',
#     plugin_name => 'dummy',
#   }
# @example
#   fluentbit {
#     input_plugins => {
#       'input-dummy' => { 'plugin_name' => 'dummy' },
#     },
#   }
# @see https://docs.fluentbit.io/manual/administration/configuring-fluent-bit/yaml/configuration-file#config_pipeline
#
# @param type Defines the pipeline type to be configured
# @param plugin_name fluent-bit plugin name to be used
# @param order Order to be applied to concat::fragment
# @param properties Hash of rest of properties needed to configure the pipeline-plugin
# @param data_dir
# @param config_dir
# @param scripts_path
# @param plugins_path
define fluentbit::pipeline (
  Enum['input','filter','output'] $type,
  String[1]                       $plugin_name,
  String[1]                       $order       = '10',
  Hash[String, Any]               $properties  = {},
  Stdlib::Absolutepath            $data_dir    = $fluentbit::data_dir,
  Stdlib::Absolutepath            $config_dir  = $fluentbit::config_dir,
  Stdlib::Absolutepath            $scripts_path = $fluentbit::scripts_path,
  Stdlib::Absolutepath            $plugins_path = $fluentbit::plugins_path,
) {
  $db_compatible_plugins = ['tail', 'systemd']

  if $type == 'input' and $plugin_name in $db_compatible_plugins {
    $db_settings = {
      'db' => "${data_dir}/${title}",
    }
  } else {
    $db_settings = {}
  }

  if $type == 'output' and $plugin_name == 'forward' {
    $upstream_settings = $properties['upstream'] ? {
      undef      => {},
      default    => {
        upstream => "${config_dir}/upstream-${properties['upstream']}.conf",
      },
    }
  } else {
    $upstream_settings = {}
  }

  if $type == 'filter' and $plugin_name == 'lua' and $properties['code'] {
    # Catch 'code' property for lua scripts and write it to disk
    file { "${scripts_path}/${title}.lua":
      ensure  => file,
      mode    => $fluentbit::config_file_mode,
      content => $properties['code'],
      notify  => Service[$fluentbit::service_name],
    }
    $script_settings = {
      'script' => "${scripts_path}/${title}.lua",
      'code'   => undef,
    }
  } else {
    $script_settings = {}
  }

  concat::fragment { "fragment-${title}":
    target  => "${plugins_path}/${type}s.conf",
    content => epp('fluentbit/pipeline.conf.epp',
      {
        name       => $plugin_name,
        type       => $type,
        properties => merge(
          $db_settings,
          {
            alias => $title,
          },
          $properties,
          $script_settings,
          $upstream_settings,
        )
      }
    ),
  }
}
