
locals {
  ansible_server-userdata = <<USERDATA
#!/usr/bin/env bash
set -e

sudo hostnamectl set-hostname ansible-server

sudo cp /tmp/tmp ~/.ssh/project_instance_key.pem
sudo chmod 400 ~/.ssh/project_instance_key.pem

sudo apt-get update
apt-get -y install ansible
apt-get install -y git
mkdir -p /home/ubuntu/kandula_project
apt-get install python3
apt-get -y install python3-pip
pip install boto3
ansible-galaxy collection install amazon.aws
sudo usermod -aG sudo ubuntu

git clone https://github.com/lihilu/kandula_ansible.git /home/ubuntu/kandula_project/

sudo mv /home/ubuntu/kandula_project/ansible/ansible.cfg /etc/ansible/ansible.cfg
USERDATA
}