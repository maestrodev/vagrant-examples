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

import "base"

# We need to setup the agent box before running the puppet agent
# with Java and Buildr so the Maven type works

# Need to define java_home for Maven type
$java_home = $operatingsystem ? {
  centOS => "/usr/lib/jvm/java",
#  Ubuntu => "/usr/lib/jvm/java",
  default => "/usr/lib/jvm/java",
}

# Install Java https://help.ubuntu.com/community/Java
# Another option: sun-java6-jdk
package { jdk:
  ensure  => installed, 
  name => $operatingsystem ? {
    centOS => "java-1.6.0-openjdk-devel",
    Ubuntu => "openjdk-6-jdk",
    default => "jdk",
  },
}

# exec { "gem update --system":
#   path => "/usr/bin:/opt/ruby/bin",
# }

# Installing Maven module pre-requisites
class { maven :
  java_home => $java_home,
  require => [Package[jdk]],
}

# Now we can start puppet as an agent, enable pluginsync
file { "/etc/sysconfig/puppet" :
  content => 'PUPPET_EXTRA_OPTS="--pluginsync"',
  notify => Service["puppet"],
  require => Class["maven"],
}
