# Changelog

All notable changes to this project will be documented in this file.


## [2026-01-19] Release 2.2.1

**Changes**

 - Notify service when pipeline changes #15, [#16](https://github.com/deric/puppet-fluentbit/pull/16)

[Full changes](https://github.com/deric/puppet-fluentbit/compare/v2.2.0...v2.2.1)

## [2025-09-17] Release 2.2.0

**Changes**

 - Added `log_level` off and `log_file` definition support [#12](https://github.com/deric/puppet-fluentbit/pull/12)
 - Support setting limit nofiles for systemd service [#13](https://github.com/deric/puppet-fluentbit/pull/13)
 - Add Debian 13 support
 - Allow `puppetlabs/apt` 10.x

[Full changes](https://github.com/deric/puppet-fluentbit/compare/v2.1.0...v2.2.0)


## [2025-07-23] Release 2.1.0

**Changes**

 - Restart service when upgrading package [#11](https://github.com/deric/puppet-fluentbit/pull/11)
 - Drop Debian 10 and Ubuntu 18.04 support

[Full changes](https://github.com/deric/puppet-fluentbit/compare/v2.0.0...v2.1.0)

## [2025-04-15] Release 2.0.0

**Changes**
 - [**BC**] `fluentbit::config_file`, `fluentbit::plugins_file`, `fluentbit::streams_file`
    and `fluentbit::parsers` file are no longer absolute paths, but are now used
    as file name, relative to `fluentbit::config_dir` and without extension.
 - [**BC**] `fluentbit::plugins_dir` is renamed to `fluentbit::pipelines_dir`
 - Don't capitalize config keys
 - Allow `puppet/systemd` 8.x

**Features**
 - Support for `yaml` config. Config format can be chosen with `fluentbit::format`.
    File extensions will be based on the chosen formant (`.conf` for `classic` and
    `.yaml` for `yaml`)
 - Add `fluentbit::includes` to include custom config files. (Only supported when
    `fluentbit::format = 'yaml'`.

**Fixes**
 - Actually honor the `fluentbit::manage_plugins_file`, `fluentbit::manage_streams_file`
    and `fluentbit::manage_parsers_file` parameters.

[Full changes](https://github.com/deric/puppet-fluentbit/compare/v1.2.0...v2.0.0)

## [2024-08-27] Release 1.2.0

**Features**
 - [make tls configurable](https://github.com/deric/puppet-fluentbit/pull/6)

**Changes**
 - Support `puppet/systemd` 7.x

[Full changes](https://github.com/deric/puppet-fluentbit/compare/v1.1.0...v1.2.0)

## [2024-06-27] Release 1.1.0

**Changes**
 - Fixed `puppetlabs/apt` requirement
 - Fixed Puppet 8 warnings
 - Replaced `merge()` function calls by native `+` operand

[Full changes](https://github.com/deric/puppet-fluentbit/compare/v1.0.0...v1.1.0)


## [2024-06-21] Release 1.0.0

**Changes**
 - **BC** use `stdlib::` prefix for puppet 4.x functions
 - Puppet 8 compatible

[Full changes](https://github.com/deric/puppet-fluentbit/compare/v0.4.0...v1.0.0)


## [2024-03-13] Release 0.4.0

**Features**
 - [Limit memory for systemd unit](https://github.com/deric/puppet-fluentbit/pull/5)


[Full changes](https://github.com/deric/puppet-fluentbit/compare/v0.3.0...v0.4.0)


## [2024-03-11] Release 0.3.0

**Bugfixes**
 - [Fix yaml issues](https://github.com/deric/puppet-fluentbit/pull/4)


[Full changes](https://github.com/deric/puppet-fluentbit/compare/v0.2.0...v0.3.0)


## [2024-02-11] Release 0.2.0

**Features**

 - [Support health checks #2](https://github.com/deric/puppet-fluentbit/pull/2)
 - Support newer systemd dependency


## [2023-07-28] Release 0.1.0

**Features**

 - Initial release

**Bugfixes**

**Known Issues**
