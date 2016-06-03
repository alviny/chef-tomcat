#
# Cookbook Name:: tomcat
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#execute 'sudo yum install java-1.7.0-openjdk-devel'
package 'java-1.7.0-openjdk-devel'
#execute 'sudo groupadd tomcat'
group 'tomcat'
user 'tomcat' do
  manage_home false
  shell '/bin/nologin'
  group 'tomcat'
  home '/opt/tomcat'
end

#execute 'wget http://mirror.sdunix.com/apache/tomcat/tomcat-8/v8.0.23/bin/apache-tomcat-8.0.23.tar.gz'
remote_file 'apache-tomcat-8.0.23.tar.gz' do
  source 'http://apachemirror.ovidiudan.com/tomcat/tomcat-8/v8.0.35/bin/apache-tomcat-8.0.35.tar.gz'
end

directory '/opt/tomcat' do
  #action :create
  group 'tomcat'

end
#TODO: NOT DESIRED STATE
execute 'tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1'

execute 'chgrp -R tomcat /opt/tomcat/conf'

directory '/opt/tomcat/conf' do
  mode '0070'
end
execute 'chmod g+r /opt/tomcat/conf/*'

execute 'chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/'

template '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service.erb'
end

execute 'systemctl daemon-reload'

service 'tomcat' do
  action [:start, :enable]
end
