# puppet-fluentbit [![Test](https://github.com/deric/puppet-fluentbit/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/deric/puppet-fluentbit/actions/workflows/test.yml)

A Puppet module to manage [Fluent Bit](https://fluentbit.io/) installation.

## Description

Fluent Bit is a fast, lightweight agent for trasporting logs, metrics, traces, etc.

In order to install the package and setup `fluent-bit` service, simply include the main class:

```puppet
include fluentbit
```

## Usage

[Fluent Bit supports wide range of inputs](https://docs.fluentbit.io/manual/pipeline/inputs)

![fluentbit pipeline]("doc/pipeline.png")

```yaml
fluentbit::inputs:
  'tail-syslog':
    pipeline: input
    plugin: tail
    properties:
      Path: /var/syslog
```
