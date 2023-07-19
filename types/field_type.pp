type Fluentbit::Field_type = Struct[{
  type  => Enum['string', 'integer', 'bool', 'float', 'hex'],
  field => String[1],
}]
