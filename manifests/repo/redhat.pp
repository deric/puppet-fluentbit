# @summary Manage yum repo
#
class fluentbit::repo::redhat {
  $releasever = $facts.dig('os', 'release', 'major')

  yumrepo { 'fluent-bit':
    ensure   => 'present',
    descr    => 'Fluent Bit',
    baseurl  => "https://packages.fluentbit.io/centos/${releasever}/",
    gpgkey   => 'https://packages.fluentbit.io/fluentbit.key',
    enabled  => '1',
    gpgcheck => '1',
  }
}
