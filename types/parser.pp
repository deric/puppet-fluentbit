type Fluentbit::Parser = Hash[String, Struct[{
  format                 => Enum['json', 'regex', 'ltsv', 'logfmt'],
  Optional[regex]        => String[1],
  Optional[time_key]     => String[1],
  Optional[time_format]  => String[1],
  Optional[time_offset]  => String[1],
  Optional[time_keep]    => Boolean,
  Optional[types]        => Array[Fluentbit::Field_type],
  Optional[decode_field] => Array[Fluentbit::Field_decoder],
}]]
