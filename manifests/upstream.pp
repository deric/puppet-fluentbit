# @summary Configures fluentbit upstream
#
# @example
#   fluentbit::upstream { 'upstreams':
#     nodes  => {
#       'n1' => { 'host' => '127.0.0.1', port => 1234 },
#       'n2' => { 'host' => '127.0.0.1', port => 1235 },
#     },
#   }
# @see https://docs.fluentbit.io/manual/administration/configuring-fluent-bit/classic-mode/upstream-servers
#
# @param upstream_name Name to be assigned to upstream, defaults to resource namevar
# @param nodes Hash of nodes assigned to this upstream
# @param config_dir Absolute path to config directory
define fluentbit::upstream (
  Hash[String, Fluentbit::UpstreamNode] $nodes,
  String[1]            $upstream_name = $name,
  Stdlib::Absolutepath $config_dir    = $fluentbit::config_dir,
) {
  file { "${config_dir}/upstream-${upstream_name}.conf":
    ensure  => file,
    mode    => $fluentbit::config_file_mode,
    content => epp('fluentbit/upstream.conf.epp',
      {
        'name'  => $upstream_name,
        'nodes' => $nodes,
      },
    ),
    notify  => Service[$fluentbit::service_name],
  }
}
