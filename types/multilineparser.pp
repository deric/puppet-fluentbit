type Fluentbit::MultilineParser = Hash[String, Struct[{
  type                    => Enum['regex'],
  rules                   => Array[Struct[{
                            state      => String[1],
                            regex      => String[1],
                            next_state => String[1],
                          }]],
  Optional[parser]        => String[1],
  Optional[key_content]   => String[1],
  Optional[flush_timeout] => Integer,
}]]
