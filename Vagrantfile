# Allocate max CPUS & RAM from host. FULL POWER! 
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
    vb.cpus = (CPUS * 0.75).round
    vb.memory = (MEM * 0.75).round
  end

  # Install zsh and oh-my-zsh
  config.vm.provision :shell, inline: "apt-get -y install zsh"
  config.vm.provision "zsh", type: "shell", privileged: false, inline: <<-SHELL
    git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
    # Change the oh my zsh default theme.
    sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/g' ~/.zshrc
    # Enable some useful plugins
    sed -i 's/plugins=(git)/plugins=(git z sudo)/g' ~/.zshrc
  SHELL
  config.vm.provision :shell, inline: "sudo chsh -s /bin/zsh vagrant"

  # Install docker & docker-Compose
  config.vm.provision "docker", type: "shell", inline: <<-SHELL
    wget -qO- https://get.docker.com/ | sh
    sudo usermod -aG docker vagrant
    newgrp docker
    sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
  SHELL
end