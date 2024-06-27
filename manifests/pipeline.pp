# @summary Configures fluentbit pipeline (input, output or filter)
#
# @note This resource add extra configuration elements for some combinations of
#  type-plugin_names, like db configuration for input plugins, or upstream configuration
#  for output-forward plugin
#
# @example
#   fluentbit::pipeline { 'input-dummy':
#     pipeline => 'input',
#     plugin   => 'dummy',
#   }
# @example
#   fluentbit {
#     input_plugins => {
#       'input-dummy' => { 'plugin' => 'dummy' },
#     },
#   }
# @see https://docs.fluentbit.io/manual/administration/configuring-fluent-bit/yaml/configuration-file#config_pipeline
#
# @param pipeline Defines the pipeline type to be configured
# @param plugin fluent-bit plugin name to be used
# @param order Order to be applied to concat::fragment
# @param properties Hash of rest of properties needed to configure the pipeline-plugin
#
define fluentbit::pipeline (
  Fluentbit::PipelineType $pipeline,
  String[1]               $plugin,
  Integer                 $order       = 10,
  Hash[String, Any]       $properties  = {},
) {
  $db_compatible_plugins = ['tail', 'systemd']

  if $pipeline == 'input' and $plugin in $db_compatible_plugins {
    $db_settings = {
      'db' => "${fluentbit::data_dir}/${title}",
    }
  } else {
    $db_settings = {}
  }

  if $pipeline == 'output' and $plugin == 'forward' {
    $upstream_settings = $properties['upstream'] ? {
      undef      => {},
      default    => {
        upstream => "${fluentbit::config_dir}/upstream-${properties['upstream']}.conf",
      },
    }
  } else {
    $upstream_settings = {}
  }

  if $pipeline == 'filter' and $plugin == 'lua' and $properties['code'] {
    # Catch 'code' property for lua scripts and write it to disk
    file { "${fluentbit::scripts_path}/${title}.lua":
      ensure  => file,
      mode    => $fluentbit::config_file_mode,
      content => $properties['code'],
      notify  => Service[$fluentbit::service_name],
    }
    $script_settings = {
      'script' => "${fluentbit::scripts_path}/${title}.lua",
      'code'   => undef,
    }
  } else {
    $script_settings = {}
  }

  concat::fragment { "pipeline-${title}":
    target  => "${fluentbit::plugins_path}/${pipeline}s.conf",
    content => epp('fluentbit/pipeline.conf.epp',
      {
        name          => $plugin,
        pipeline_type => $pipeline,
        order         => $order,
        properties    => $db_settings
        + { alias => $title }
        + $properties
        + $script_settings
        + $upstream_settings,
      }
    ),
  }
}
