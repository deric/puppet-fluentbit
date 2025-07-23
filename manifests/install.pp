# @summary Installs fluentbit package
#
# @private
class fluentbit::install {
  assert_private()

  stdlib::ensure_packages([$fluentbit::package_name], {
      ensure  => $fluentbit::package_ensure,
  })

  if ($fluentbit::manage_service and $fluentbit::restart_on_upgrade) {
    # restart service upon upgrade
    Package[$fluentbit::package_name] ~> Service[$fluentbit::service_name]
  }

  case $facts['os']['family'] {
    'Debian': {
      Apt::Source['fluentbit']
      -> Class['apt::update']
      -> Package[$fluentbit::package_name]
    }
    default: {}
  }
}
