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

# disable firewalling
service { "iptables" :
  ensure => stopped,
}

$jdbc = {
  url => "jdbc:derby://localhost:1527/sonar;create=true",
  driver_class_name => "org.apache.derby.jdbc.ClientDriver",
  validation_query => "values(1)",
  username => "sonar",
  password => "sonar",
}

$java_home = "/usr/lib/jvm/java-1.6.0"

define install-gem ($version = '') {
  exec { "gem $name $version":
    path => "/usr/bin:/opt/ruby/bin",
    environment => "JAVA_HOME=${java_home}",
    command => "gem install $name --version $version --no-rdoc --no-ri",
    unless => "gem query -i --name-matches $name --version $version",
    logoutput => true,
  }
}

# Install Java https://help.ubuntu.com/community/Java
# Another option: sun-java6-jdk
package { jdk:
  ensure => installed, 
  name   => $operatingsystem ? {
    centOS => "java-1.6.0-openjdk-devel",
    Ubuntu => "openjdk-6-jdk",
    default => "jdk",
  },
} ->

class { "sonar" :
  version => "2.11",
}
