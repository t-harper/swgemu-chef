# -*- mode: ruby -*-
# vi: set ft=ruby :

remote_file "/tmp/mysql-community-release-el7-5.noarch.rpm" do
  source "http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm"
end

package 'mysql_community_repo' do
  source "/tmp/mysql-community-release-el7-5.noarch.rpm"
end

%w(
  gcc-c++
  make
  gdb
  automake
  git
  readline-devel
  openssl-devel
  mysql-community-server
  mysql-community-devel
  java-1.8.0-openjdk-devel
  vim-enhanced
  git
  libdb
  libdb-cxx
  libdb-devel
  libdb-cxx-devel
).each do |p|
  package p do
    action :install
  end
end

service "mysqld" do
  action [ :enable, :start ]
end

bash "install_default_database" do
  code <<-EOF
  mysql -u root -e "GRANT ALL PRIVILEGES ON swgemu.* TO 'swgemu'@'127.0.0.1' IDENTIFIED BY 'development'"
  mysql -u root < /vagrant/MMOCoreORB/sql/swgemu.sql;
  mysql -u root swgemu < /vagrant/MMOCoreORB/sql/datatables.sql;
  mysql -u root swgemu < /vagrant/MMOCoreORB/sql/mantis.sql;
  EOF
  not_if "mysql -u root -e 'show databases' | grep swgemu"
end

link "/usr/lib64/libmysqlclient.so" do
  to "/usr/lib64/mysql/libmysqlclient.so"
end

remote_file "/tmp/lua-5.3.3.tar.gz" do
  source "https://www.lua.org/ftp/lua-5.3.3.tar.gz"
end

bash 'install_lua' do
  cwd '/tmp'
  code <<-EOF
  tar -xf lua-5.3.3.tar.gz
  cd lua-5.3.3
  make clean
  make linux
  make install
  EOF
  not_if { ::File.exist?("/usr/local/bin/luac") }
end

link "/usr/local/bin/idlc" do
  to "/vagrant/MMOEngine/bin/idlc"
end

template "/etc/profile.d/swgemu.sh" do
  source "/vagrant/templates/swgemu.sh.erb"
  local true
  owner "root"
  group "root"
  mode "0644"
end


file "/vagrant/MMOEngine/bin/idlc" do
  mode "0755"
end

template "/vagrant/MMOCoreORB/bin/conf/config.lua" do
  source "/vagrant/templates/config.lua.erb"
  local true
  owner "vagrant"
  group "vagrant"
  mode "0644"
end
