type Fluentbit::UpstreamNode = Struct[{
  host => String[1],
  port => Integer,
  Optional[tls]  => Enum['On', 'Off'],
  Optional[tls_verify] => Enum['On', 'Off']
}]
