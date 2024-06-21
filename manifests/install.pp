# @summary Installs fluentbit package
#
# @private
class fluentbit::install {
  assert_private()

  stdlib::ensure_packages([$fluentbit::package_name], {
      ensure  => $fluentbit::package_ensure,
  })

  case $facts['os']['family'] {
    'Debian': {
      Apt::Source['fluentbit']
      -> Class['apt::update']
      -> Package[$fluentbit::package_name]
    }
    default: {}
  }
}
