# @summary Installs fluentbit package
#
# @private
class fluentbit::install {

  assert_private()

  ensure_packages([$fluentbit::package_name], {
    ensure  => $fluentbit::package_ensure,
  })
}
