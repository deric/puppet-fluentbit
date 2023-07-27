type Fluentbit::PipelinePlugin = Hash[String, Struct[{
  plugin               => String[1],
  Optional[pipeline]   => Fluentbit::PipelineType,
  Optional[order]      => Integer,
  Optional[properties] => Hash,
}]]
