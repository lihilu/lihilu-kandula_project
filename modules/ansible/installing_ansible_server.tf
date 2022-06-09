
locals {
  ansible_server-userdata = <<USERDATA
#!/usr/bin/env bash
set -e

sudo hostnamectl set-hostname ansible-server

sudo apt-get update
apt-get -y install ansible
apt-get install -y git
mkdir -p /home/ubuntu/kandula_project
apt-get install python3
apt-get -y install python3-pip
pip install boto3
ansible-galaxy collection install amazon.aws
sudo usermod -aG sudo ubuntu
sleep 9m


git clone https://github.com/lihilu/kandula_ansible.git /home/ubuntu/kandula_project/ && echo "cloned"
sleep 1m


echo "Creating cron..."
sudo sh -c 'echo "#!/bin/bash \nsudo ansible-playbook -i /home/ubuntu/kandula_project/ansible/inventory_aws_ec2.yml /home/ubuntu/kandula_project/ansible/playbook_consul.yml" > /etc/cron.hourly/playbookrunforconsol.sh'
sudo chmod +x /etc/cron.hourly/playbookrunforconsol.sh
sudo mv /home/ubuntu/kandula_project/ansible/ansible.cfg /etc/ansible/ansible.cfg
ansible-playbook -i /home/ubuntu/kandula_project/ansible/inventory_aws_ec2.yml /home/ubuntu/kandula_project/ansible/playbook_consul.yml

USERDATA
}