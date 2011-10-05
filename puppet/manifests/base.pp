# Copyright 2011 MaestroDev
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

filebucket { main: server => 'puppet' }

File { backup => main }
Exec { path => "/usr/bin:/usr/sbin:/bin:/sbin:/usr/local/bin" }
Maven { repos => "http://repo1.maven.apache.org/maven2" }

# disable firewalling, puppet master will be blocked otherwise
service { "iptables" :
  ensure => stopped,
}

file { "/etc/hosts" :
  content => template("hosts.erb")
}

service { "puppet" :
  ensure => running,
  hasrestart => true,
  hasstatus => true,
  enable => true,
  require => [File["/etc/sysconfig/puppet", "/etc/hosts"], Service["iptables"]],
}
