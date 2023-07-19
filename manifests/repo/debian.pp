# @summary Manage fluentbit apt repo
#
# @param key_location
# @param key_fingerprint
# @param flavor
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
