# @summary Manage fluentbit apt repo
#
# @param key_fingerprint
#   GPG key identifier of the repository
# @param key_location
#   GPG key URI
# @param flavour
#   e.g. Debian/Ubuntu
# @param release
#   distribution code name
class fluentbit::repo::debian (
  Stdlib::HTTPUrl $key_location,
  String[1] $key_fingerprint,
  String[1] $flavour = $facts['os']['distro']['id'],
  String[1] $release = $facts['os']['distro']['codename'],
) {
  contain 'apt'

  $_flavour = downcase($flavour)

  apt::source { 'fluentbit':
    comment  => 'Official Treasure Data repository for Fluent-Bit',
    location => "https://packages.fluentbit.io/${_flavour}/${release}",
    release  => $release,
    repos    => 'main',
    key      => {
      id     => $key_fingerprint,
      source => $key_location,
    },
    include  => {
      src => false,
      deb => true,
    },
  }
}
