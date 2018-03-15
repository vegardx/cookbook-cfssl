# chef-cfssl-cookbook

Installs and configures cfssl as both a client and server. Heavily inspired from
[chef-cfssl](https://github.com/onetwotrip/chef-cfssl) and [puppet-cfssl](https://github.com/rehanone/puppet-cfssl).

*Probably not working yet.*

## Depends
- aws

## Intro
Cookbook to distribute short lived certificates. Using Parameter Store for secure introduction of authentication key and
storage of CA keys.

## Supported Platforms
- Debian 9
- Ubuntu 16.04 (probably)
