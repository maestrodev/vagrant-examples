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

# Puppet configuration to be served from the master

node "client" {
  notice("Configuring node 'client'")

  maven { "/tmp/maven-core-2.2.1.jar":
    id => "org.apache.maven:maven-core:jar:2.2.1",
    #repos => ["http://repo1.maven.apache.org/maven2","http://mirrors.ibiblio.org/pub/mirrors/maven2"],
  }
}
