# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "https://github.com/holms/vagrant-centos7-box/releases/download/7.1.1503.001/CentOS-7.1.1503-x86_64-netboot.box"

  config.vm.provision "chef_apply" do |chef|
    chef.recipe = File.read("swgemu_base.rb")
  end

  config.vm.provider 'virtualbox' do |v|
    v.memory = 4096
    v.cpus = 2
  end

  for i in 44452..44463
    config.vm.network :forwaded_port, guest: i, host:i
  end
end
