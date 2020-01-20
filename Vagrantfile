LINUX = RUBY_PLATFORM =~ /linux/
OSX = RUBY_PLATFORM =~ /darwin/
WINDOWS = (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
if OSX
  CPUS = `sysctl -n hw.ncpu`.to_i
  MEM = `sysctl -n hw.memsize`.to_i / 1024 / 1024
end
if LINUX
  CPUS = `nproc`.to_i
  MEM = `sed -n -e '/^MemTotal/s/^[^0-9]*//p' /proc/meminfo`.to_i / 1024
end
if WINDOWS
  CPUS = `wmic computersystem get numberofprocessors`.split("\n")[2].to_i
  MEM = `wmic OS get TotalVisibleMemorySize`.split("\n")[2].to_i / 1024
end

Vagrant.configure(2) do |config|
  config.vm.box = "bento/ubuntu-18.04"
  config.vm.network "private_network", ip: "192.168.10.101"
  config.ssh.forward_agent = true
  config.vm.provider "virtualbox" do |vb|
    vb.name = "dockerbox"
    vb.cpus = CPUS
    vb.memory = MEM
  end

  # Install Docker & Docker-Compose
  config.vm.provision "shell", inline: <<-SHELL
    wget -qO- https://get.docker.com/ | sh
    sudo usermod -aG docker vagrant
    newgrp docker
    sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
  SHELL
end



