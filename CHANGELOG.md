# Changelog

All notable changes to this project will be documented in this file.

## [UNRELEASED] 2.0.0

- [**BC**] `fluentbit::config_file` is no longer an absolute path to config file. Now used as a file name, extension is used according to `fluentbit::format` (`.yaml` or `.conf`).

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
