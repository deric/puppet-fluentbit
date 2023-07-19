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
  }
}
