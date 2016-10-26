# == Class: multipath
#
# Puppet module to install multipath
#
# === Parameters
#
# [*blacklist*]
#   Hash of "Type" => [data1, data2, ...]
#   Valid types are "wwid", "devnode", "device"
#   Data can be either just a string or an hash of key => values
#   For "wwid" and "devnode" valid dataare strings
#   For "device" data are hashes 
#   Example:
#     blacklist => {
#                   "wwid" => ["26353900f02796769"],
#                   "devnode" => ["^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*","^hd[a-z]"],
#                   "device"  => [{"vendor" => "*", "product" => "Universal Xport"}]
#                  }
#     }
#
# [*blacklist_exceptions*]
#   Hash of "Type" => "data", exceptions to the blacklist parameters
#
# [*max_fds*]
#   Maximum number of fds
#
# [*polling_interval*]
#   Interval between two path checks in seconds
#
# [*service_enable*]
#   Enable the service if true (default)
#
# [*user_friendly_names*]
#   Use friendly names if true (default)
#
# === Examples
#
#  class { 'multipath':
#    blacklist => {
#                   "wwid" => ["26353900f02796769"],
#                   "devnode" => ["^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*","^hd[a-z]"],
#                   "device"  => [{"vendor" => "*", "product" => "Universal Xport"}]
#    }
#  }
#
# === Authors
#
# Alessandro De Salvo <Alessandro.DeSalvo@roma1.infn.it>
#
# === Copyright
#
# Copyright 2014 Alessandro De Salvo, unless otherwise noted.
#
class multipath (
  $blacklist = undef,
  $blacklist_exceptions = undef,
  $failback = undef,
  $getuid_callout = undef,
  $max_fds = 8192,
  $no_path_retry = undef,
  $path_checker = undef,
  $path_grouping_policy = undef,
  $polling_interval = undef,
  $prio_callout = undef,
  $rr_min_io = undef,
  $rr_weight = undef,
  $selector = undef,
  $udev_dir = undef,
  $user_friendly_names = true,
  $multipaths = undef,
  $devices = undef,
  $service_enable = true,
) {

  include multipath::params

  package {$multipath::params::packages:
    ensure => latest,
  }

  file {$multipath::params::conf:
    ensure => present,
    owner  => root,
    group  => root,
    mode   => 0644,
    content => template("multipath/multipath.conf.erb"),
  }

  service {$multipath::params::service:
    ensure => running,
    enable => $service_enable,
    subscribe => File[$multipath::params::conf],
    require => Package[$multipath::params::packages],
  }
}
