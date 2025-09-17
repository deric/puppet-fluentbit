# @summary Manage fluentbit installation
#
# @see https://docs.fluentbit.io/manual/
#
# @param format
#   Configuration files format, either `classic` or `yaml`.
#   `classic` is to be depcrecated in fluent-bit end of 2025,
#   and does not support all options available in `yaml` (like processors).
#   When using the official package, with `$format = 'yaml'`,
#   you will need to override the systemd service to use the yaml config file
#   (set `service_override_unit_file = true`), until upstream fixes their packaging.
#
# @param manage_package_repo Installs the package repositories
# @param inputs Hash of the INPUT plugins to be configured
# @param outputs Hash of the OUTPUT plugins to be configured
# @param filters Hash of the filter to be configured
#
# @param package_ensure
#   Whether to install the Fluentbit package, and what version to install.
#   Values: 'present', 'latest', or a specific version number.
#   Default value: 'present'.
#
# @param package_name
#   Specifies the Fluentbit package to manage.
#
# @param service_name
#   The fluentbit service name
#
# @param manage_service
#   Whether to manage the service. Default: true
#
# @param service_enable
#   Whether to enable the fluentbit service at boot. Default: true
#
# @param service_ensure
#   Whether the fluentbit service should be running. Default: 'running'
#
# @param service_has_status
#   Whether the service has a functional status command. Default: true
#
# @param service_has_restart
#   Whether the service has a restart command. Default: true
#
# @param service_restart_command
#   Optional command for restarting service
#
# @param service_override_unit_file
#   Override service definition provided by package with a drop-in unit file.
#
# @param restart_on_upgrade
#   Whether restart fluentbit service when upgrading package
#
# @param memory_max
#   Limit memory usage for the systemd unit (requires `service_override_unit_file` set to `true`)
#   Memory limit as a string with K, M, G or T suffix, e.g. `2G`
#
# @param limit_nofile
#   Limit max number of opened files for systemd service (requires `service_override_unit_file` set to `true`)
#
# @param manage_config_dir
#   Whether to manage the configuration directory.
#   When enabled, will remove all unmanaged files from the directory the
#   configuration resides in.
#   Default value: true

# @param manage_data_dir
#   Whether to manage the data directory.
#   Default value: true

# @param manage_storage_dir
#   Whether to manage the storage directory. `storage_path` must be defined.
#   Default value: true
#
# @param config_dir
#   Absolute path to directory where configuration files are stored.
#
# @param pipelines_dir
#   Directory name for pipelines, relative to `$config_dir`
#
# @param scripts_dir
#   Directory name for scripts, relative to `$config_dir`
#
# @param data_dir
#   Path to data directory that will be used by plugins using DB feature.
#
# @param binary_file
#   Path of the daemon binary.
#
# @param config_file
#   The name of the main config file, relative to `$config_dir` and  without extension.
#   Default `fluent-bit`.
#
# @param config_file_mode
#   File mode to apply to the daemon configuration file
#
# @param config_folder_mode
#   File mode to apply folders managed by the module
#
# @param storage_path
#   Set an optional location in the file system to store streams and chunks of data.
#   If this parameter is not set, Input plugins can only use in-memory buffering.
#
# @param storage_sync
#   Configure the synchronization mode used to store the data into the file system.
#   It can take the values normal or full.
#   Default value: 'normal'
#
# @param storage_checksum
#   Enable the data integrity check when writing and reading data from the filesystem.
#   The storage layer uses the CRC32 algorithm.
#   Default value: false
#
# @param storage_backlog_mem_limit
#   If the input plugin has enabled filesystem storage type, this property sets the maximum
#   number of Chunks that can be up in memory.
#   This is the setting to use to control memory usage when you enable storage.type filesystem.
#   Default value: 128
#
# @param storage_max_chunks_up
#   If storage.path is set, Fluent Bit will look for data chunks that were
#   not delivered and are still in the storage layer, these are called backlog data.
#   This option configure a hint of maximum value of memory to use when processing these records.
#   Default value: 5M
#
# @param storage_metrics
#   If http_server option has been enabled in the main [SERVICE] section, this option registers a new
#   endpoint where internal metrics of the storage layer can be consumed.
#   Default value: false
#
# @param storage_delete_irrecoverable_chunks
#   When enabled, irrecoverable chunks will be deleted during runtime, and any other irrecoverable chunk
#   located in the configured storage path directory will be deleted when Fluent-Bit starts.
#   Default value: false
#
# @param health_check
#   Enable or disable health_check
#   Default Off
#
# @param hc_errors_count
#   Only in use if health_check is enabled. The error count after which the healcheck returns an error.
#   Default 5
#
# @param hc_retry_failure_count
#   Only in use if health_check is enabled. Retry count till a check returns an error
#   Default 5
#
# @param hc_period
#   Only in use if health_check is enabled. Time period by second to count the error and retry failure data point
#   Default 60
#
# @param manage_plugins_file
#   Whether to manage the enabled external plugins
#
# @param plugins_file
#   Name of the plugins configuration file, relative to `$config_dir`,
#   and without file extension.
#
# @param plugins
#   List of external plugin objects to enable
#
# @param manage_streams_file
#   Whether to manage the stream processing configuration
#
# @param streams_file
#   Name of the streams configuration file, relative to `$config_dir`,
#   and without file extension.
#
# @param streams
#   Stream processing tasks
#
# @param upstreams
#   Upstreams used by forward plugins
#
# @param manage_parsers_file
#   Whether to manage the parser definitions
#
# @param parsers_file
#   Name of the parsers configuration file, relative to `$config_dir`,
#   and without file extension.
#
# @param parsers
#   List of parser definitions.
#   The default value consists of all the available definitions provided by the
#   upstream project as of version 1.3
#
# @param multiline_parsers
#   List of parser definitions.
#   The default value consists of all the available definitions provided by the
#   upstream project as of version 2.1
#
# @param flush
#   Set the flush time in seconds. Everytime it timeouts, the engine will flush the records to the output plugin.
# @param grace
#   Set the grace time in seconds. The engine loop uses a Grace timeout to define the wait time on exit.
# @param daemon
#   Boolean value to set if Fluent Bit should run as a Daemon (background) or not. Allowed values are: yes, no, on and off.
# @param dns_mode
#   Sets the primary transport layer protocol used by the asynchronous DNS resolver.
# @param log_file
#   Specify the absolute path to the log file for Fuent Bit service itself
# @param log_level
#   Set the logging verbosity level.
#   Values are: off, error, warn, info, debug and trace. Values are accumulative,
#   e.g: if 'debug' is set, it will include error, info and debug.
#   Note that trace mode is only available if Fluent Bit was built with the WITH_TRACE option enabled.
# @param http_server
#   Enable built-in HTTP Server
# @param http_listen
#   Set listening interface for HTTP Server when it's enabled
# @param http_port
#   Set TCP Port for the HTTP Server
# @param coro_stack_size
#   Set the coroutines stack size in bytes.
#   The value must be greater than the page size of the running system.
# @param scheduler_cap
#   Set a maximum retry time in seconds. The property is supported from v1.8.7.
# @param scheduler_base
#   Sets the base of exponential backoff. The property is supported from v1.8.7.
# @param json_convert_nan_to_null
#   If enabled, NaN is converted to null when fluent-bit converts msgpack to json.
#
# @param service
#   Override fluent-bit service configuration
# @param variables
#   macro definitions to use in the configuration file
#   the will be registered using the *@SET* command or using Env section in YAML syntax.
#
# @param includes
#   Extra files to include in the config.
#   (Only supported in `yaml` config format).
#
# @example
#   include fluentbit
class fluentbit (
  Enum['classic', 'yaml']          $format,
  Boolean                          $manage_package_repo,
  String[1]                        $package_ensure,
  String[1]                        $package_name,

  Boolean                          $manage_service,
  Boolean                          $service_enable,
  Boolean                          $service_has_status,
  Optional[String[1]]              $service_restart_command,
  Boolean                          $service_has_restart,
  Boolean                          $service_override_unit_file,
  Stdlib::Ensure::Service          $service_ensure,
  String[1]                        $service_name,
  Boolean                          $restart_on_upgrade,
  Optional[Integer]                $limit_nofile = undef,

  Boolean                          $manage_config_dir,
  Boolean                          $manage_data_dir,
  Boolean                          $manage_storage_dir,

  Stdlib::Absolutepath             $binary_file,
  Stdlib::Absolutepath             $config_dir,
  Stdlib::Absolutepath             $data_dir,
  String                           $config_file,
  Stdlib::Filemode                 $config_file_mode,
  Stdlib::Filemode                 $config_folder_mode,
  Integer                          $flush,
  Integer                          $grace,
  Boolean                          $daemon,
  Enum['UDP', 'TCP']               $dns_mode,
  Fluentbit::Loglevel              $log_level,
  Boolean                          $manage_parsers_file,
  String                           $parsers_file,
  Boolean                          $manage_plugins_file,
  String                           $plugins_file,
  Boolean                          $manage_streams_file,
  String                           $streams_file,
  Boolean                          $http_server,
  Stdlib::IP::Address::Nosubnet    $http_listen,
  Stdlib::Port                     $http_port,
  Integer                          $scheduler_cap,
  Integer                          $scheduler_base,
  Boolean                          $json_convert_nan_to_null,

  Optional[Stdlib::Absolutepath]   $storage_path,
  Optional[Enum['normal', 'full']] $storage_sync,
  Boolean                          $storage_checksum,
  Optional[Integer]                $storage_max_chunks_up,
  Boolean                          $storage_metrics,
  Boolean                          $storage_delete_irrecoverable_chunks,
  Optional[String[1]]              $storage_backlog_mem_limit,

  Boolean                          $health_check,
  Integer                          $hc_errors_count,
  Integer                          $hc_retry_failure_count,
  Integer                          $hc_period,

  Integer                          $coro_stack_size,
  String                           $pipelines_dir,
  String                           $scripts_dir,

  Fluentbit::Parser                $parsers,
  Fluentbit::PipelinePlugin        $inputs            = {},
  Fluentbit::PipelinePlugin        $outputs           = {},
  Fluentbit::PipelinePlugin        $filters           = {},
  Hash[String, Hash]               $upstreams         = {},
  Hash                             $variables         = {},
  Hash                             $service           = {},
  Fluentbit::MultilineParser       $multiline_parsers = {},
  Fluentbit::Stream                $streams           = {},
  Array[Stdlib::Absolutepath]      $plugins           = [],
  Optional[String[1]]              $memory_max        = undef,
  Optional[Stdlib::Absolutepath]   $log_file          = undef,
  Array[Stdlib::Absolutepath]      $includes          = [],
) {
  $pipelines_path = "${config_dir}/${pipelines_dir}"
  $scripts_path = "${config_dir}/${scripts_dir}"
  $config_ext = $format ? {
    'classic' => 'conf',
    'yaml'    => 'yaml',
  }
  $config_path = "${config_dir}/${config_file}.${config_ext}"
  $parsers_path = "${config_dir}/${parsers_file}.${config_ext}"
  $plugins_path = "${config_dir}/${plugins_file}.${config_ext}"
  $streams_path = "${config_dir}/${streams_file}.${config_ext}"

  contain fluentbit::repo
  contain fluentbit::install
  contain fluentbit::config
  contain fluentbit::service

  Class['fluentbit::repo']
  -> Class['fluentbit::install']
  -> Class['fluentbit::config']
  ~> Class['fluentbit::service']

  $inputs.each |$name, $conf| {
    create_resources(fluentbit::pipeline, { $name => { 'pipeline' => 'input' } + $conf })
  }

  $outputs.each |$name, $conf| {
    create_resources(fluentbit::pipeline, { $name => { 'pipeline' => 'output' } + $conf })
  }

  $filters.each |$name, $conf| {
    create_resources(fluentbit::pipeline, { $name => { 'pipeline' => 'filter' } + $conf })
  }

  create_resources(fluentbit::upstream, $upstreams)
}
