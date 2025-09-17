# systemd nofile limit, e.g 1024:4096 or simply 2048 (same soft and hard limit)
type Fluentbit::NoFileLimit = Variant[
  Integer[-1],
  Pattern['^(infinity|\d+(:(infinity|\d+))?)$']
]
