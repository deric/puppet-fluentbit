# @summary Manage fluent-bit service
#
# @private
class fluentbit::service {
  assert_private()

  if $fluentbit::manage_service {
    service { $fluentbit::service_name:
      ensure     => $fluentbit::service_ensure,
      enable     => $fluentbit::service_enable,
      hasstatus  => $fluentbit::service_has_status,
      hasrestart => $fluentbit::service_has_restart,
      restart    => $fluentbit::service_restart_command,
      name       => $fluentbit::service_name,
    }

    if $fluentbit::service_override_unit_file {
      systemd::unit_file { "${fluentbit::service_name}.service":
        ensure  => present,
        notify  => Service[$fluentbit::service_name],
        content => epp('fluentbit/fluentbit.service.epp',
          {
            'binary_file' => $fluentbit::binary_file,
            'config_file' => $fluentbit::config_file,
            'memory_max'  => $fluentbit::memory_max,
          }
        ),
      }
    }
  }
}
