
locals {
  ansible_server-userdata = <<USERDATA
#!/usr/bin/env bash
set -e

sudo hostnamectl set-hostname ansible-server
sudo usermod -aG sudo ubuntu
sudo apt-get update
sudo apt-get -y install ansible
sudo apt-get install -y git
mkdir -p /home/ubuntu/kandula_project
sudo apt-get install python3
sudo apt-get -y install python3-pip

sudo apt install awscli -y
pip install --upgrade --user awscli
pip install boto3
ansible-galaxy collection install amazon.aws
ansible-galaxy collection install community.postgresql

sleep 30s
sudo apt-get update
sudo curl -o kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl
sudo chmod +x ./kubectl
sudo mkdir -p $HOME/bin && sudo cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin


sudo wget https://get.helm.sh/helm-v3.4.1-linux-amd64.tar.gz
sudo tar xvf helm-v3.4.1-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin
sudo rm helm-v3.4.1-linux-amd64.tar.gz
sudo rm -rf linux-amd64

sleep 30s
git clone https://github.com/lihilu/kandula_ansible.git /home/ubuntu/kandula_project/ && echo "cloned"
sleep 1m

echo "coping db var file for ansible"
sudo cp /tmp/vars.yml /home/ubuntu/kandula_project/ansible/roles/rds/vars/vars.yml

sudo chown -R ubuntu *
echo "Creating cron..."
sudo sh -c 'echo "#!/bin/bash \nsudo ansible-playbook -i /home/ubuntu/kandula_project/ansible/inventory_aws_ec2.yml /home/ubuntu/kandula_project/ansible/playbook_consul.yml" > /etc/cron.hourly/playbookrunforconsol.sh'
sudo chmod +x /etc/cron.hourly/playbookrunforconsol.sh
sudo mv /home/ubuntu/kandula_project/ansible/ansible.cfg /etc/ansible/ansible.cfg
ansible-playbook -i /home/ubuntu/kandula_project/ansible/inventory_aws_ec2.yml /home/ubuntu/kandula_project/ansible/playbook_consul.yml
sleep 1m

sudo chown -R ubuntu /home/ubuntu/*
echo "connecting kube"
sudo aws eks --region=us-east-1 update-kubeconfig --name kandula-project-eks

USERDATA
}