# @summary Configures fluentbit pipeline (input, output or filter)
#
# @note This resource add extra configuration elements for some combinations of
#  type-plugin_names, like db configuration for input plugins, or upstream configuration
#  for output-forward plugin
#
# @note If a LUA filter with a `code` property is created in `classic` config format,
#  then the `code` contents are written to a file, and a `script` property is added to point
#  to this file. When `yaml` config format is used, the `code` property will be included in
#  the resulting yaml file as-is, without adding a `script` property.
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
        upstream => "${fluentbit::config_dir}/upstream-${properties['upstream']}.${fluentbit::config_ext}",
      },
    }
  } else {
    $upstream_settings = {}
  }

  if $pipeline == 'filter' and $plugin == 'lua' and $properties['code'] and $fluentbit::format == 'classic' {
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

  if $fluentbit::format == 'classic' {
    concat::fragment { "pipeline-${title}":
      target  => "${fluentbit::pipelines_path}/${pipeline}s.conf",
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
      notify  => Service[$fluentbit::service_name],
    }
  } elsif $fluentbit::format == 'yaml' {
    $clean_name = regsubst($name, "^${pipeline}-", '')
    file { "${fluentbit::pipelines_path}/${pipeline}-${clean_name}.yaml":
      content => stdlib::to_yaml(
        {
          pipeline => {
            "${pipeline}s" => [
              {
                name  => $plugin,
                alias => $title,
              }
              + $db_settings
              + $properties
              + $script_settings
              + $upstream_settings,
            ],
          },
        }
      ),
      notify  => Service[$fluentbit::service_name],
    }
  } else {
    fail('Welp, something fucked up')
  }
}
