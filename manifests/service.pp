# @summary Manage fluent-bit service
#
# @private
class fluentbit::service {
  assert_private()

  if $fluentbit::manage_service {
    service { 'fluentbit':
      ensure     => $fluentbit::service_ensure,
      enable     => $fluentbit::service_enable,
      hasstatus  => $fluentbit::service_has_status,
      hasrestart => $fluentbit::service_has_restart,
      restart    => $fluentbit::service_restart_command,
      name       => $fluentbit::service_name,
    }

    systemd::unit_file { "${fluentbit::service_name}.service":
      ensure  => present,
      notify  => Service['fluentbit'],
      content => epp('fluentbit/fluentbit.service.epp',
        {
          'binary_file' => $fluentbit::binary_file,
          'config_file' => $fluentbit::config_file,
        }
      ),
    }
  }
}
