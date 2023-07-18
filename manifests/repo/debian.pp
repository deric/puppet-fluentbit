# @summary Manage fluentbit apt repo
#
# @private
class fluentbit::repo::debian {
  assert_private()

  $flavour = dig($facts, 'os', 'distro', 'id')
  $release = dig($facts, 'os', 'distro', 'codename')
  $supported = $flavour ? {
    'Debian' => [
      'stretch',
      'buster',
      'bullseye',
      'bookworm',
    ],
    'Ubuntu' => [
      'xenial',
      'bionic',
    ],
    'Raspbian' => [
      'stretch',
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
      id     => $fluentbit::repo_key_fingerprint,
      source => $fluentbit::repo_key_location,
    },
    include  => {
      src => false,
      deb => true,
    },
  }

  Apt::Source['fluentbit']
    -> Class['::apt::update']
    -> Package['fluentbit']
}
