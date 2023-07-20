type Fluentbit::PipelinePlugin = Hash[String, Struct[{
  pipeline             => Fluentbit::PipelineType,
  plugin               => String[1],
  Optional[order]      => Integer,
  Optional[properties] => Hash,
}]]
