# puppet-fluentbit [![Puppet Forge](http://img.shields.io/puppetforge/v/deric/fluentbit.svg)](https://forge.puppet.com/modules/deric/fluentbit) [![Test](https://github.com/deric/puppet-fluentbit/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/deric/puppet-fluentbit/actions/workflows/test.yml)

A Puppet module to manage [Fluent Bit](https://fluentbit.io/) installation.

## Description

Fluent Bit is a fast, lightweight agent for trasporting logs, metrics, traces, etc.

In order to install the package and setup `fluent-bit` service, simply include the main class:

```puppet
include fluentbit
```

## Usage

[Fluent Bit supports wide range of inputs](https://docs.fluentbit.io/manual/pipeline/inputs)

![fluentbit pipeline](img/pipeline.png)

Define some inputs:
```yaml
fluentbit::inputs:
  'tail-syslog':
    plugin: tail
    properties:
      path: /var/syslog
```

[outputs](https://docs.fluentbit.io/manual/pipeline/outputs):
```yaml
fluentbit::outputs:
  'prometheus':
    plugin: prometheus_exporter
    properties:
      match: nginx.metrics.*
      host: 0.0.0.0
      port: 2021
```

Service configuration:
```yaml
fluentbit::service:
  log_level: debug
  mem_buf_limit: 50MB
  storage.pause_on_chunks_overlimit: 'on'
```

Use specific `fluent-bit` version:

```yaml
fluentbit::package_ensure: 3.2.9
```

## Configuration


Limit maximum memory usage per systemd unit:
```yaml
fluentbit::service_override_unit_file: true
fluentbit::memory_max: 2G
```
You increase number of opened file descriptors for `fluent-bit.service`. Either by passing single value like `32768` (same soft and hard limit) or by setting both limits:
```yaml
limit_nofile: '8192:16384'
```

All Puppet variables are documented in [REFERENCE.md](./REFERENCE.md).

### Acceptance tests

```
BEAKER_destroy=no BEAKER_setfile=debian11-64 bundle exec rake beaker
```
