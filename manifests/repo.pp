# @summary Setup the fluentbit repo
#
# @private
class fluentbit::repo {
  assert_private()

  if $fluentbit::manage_package_repo {
    case $facts['os']['family'] {
      'Debian': {
        contain 'fluentbit::repo::debian'
      }
      'RedHat': {
        contain 'fluentbit::repo::redhat'
      }
      default: {
        fail("${module_name} module doesn't support ${facts['os']['family']}")
      }
    }
  }
}
