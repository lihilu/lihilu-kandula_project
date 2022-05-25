locals {
jenkins_home = "/home/ubuntu/jenkins_home"
jenkins_server_userdata = <<USERDATA
#!/usr/bin/env bash
set -e

sudo hostnamectl set-hostname jenkins_server
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

USERDATA



jenkins_agent_userdata = <<USERDATA
#!/usr/bin/env bash
set -e
#sudo hostnamectl set-hostname jenkins_agent
sudo apt install docker.io -y
# sudo systemctl start docker
# sudo systemctl enable docker
sudo usermod -aG docker ubuntu
mkdir -p ${local.jenkins_home}
sudo chown -R 1000:1000 ${local.jenkins_home}
sudo chmod 666 /var/run/docker.sock

USERDATA
}