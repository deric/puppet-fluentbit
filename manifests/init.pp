# @summary Manage fluentbit installation
#
# @param manage_package_repo
# @param package_ensure
# @param package_name
#
# @example
#   include fluentbit
class fluentbit (
  Boolean $manage_package_repo,
  String[1] $package_ensure,
  String[1] $package_name,
) {
  contain fluentbit::repo
  contain fluentbit::install
  contain fluentbit::config
  contain fluentbit::service

  Class['fluentbit::repo']
  -> Class['fluentbit::install']
  -> Class['fluentbit::config']
  ~> Class['fluentbit::service']
}
