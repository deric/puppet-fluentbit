# @summary Manage fluentbit apt repo
#
# @param key_location
# @param key_fingerprint
class fluentbit::repo::debian(
  Stdlib::HTTPUrl $key_location,
  String[1] $key_fingerprint,
  ) {

  $flavour = dig($facts, 'os', 'distro', 'id')
  $release = dig($facts, 'os', 'distro', 'codename')
  $supported = $flavour ? {
    'Debian' => [
      'buster',
      'bullseye',
      'bookworm',
    ],
    'Ubuntu' => [
      'xenial',
      'bionic',
      'focal',
      'jammy'
    ],
    'Raspbian' => [
      'buster',
      'bullseye',
      'bookworm',
    ],
    default => [],
  }

  unless $release in $supported {
    fail("OS ${flavour}/${release} is not supported")
  }

  contain '::apt'

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
