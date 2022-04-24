
locals {
 ansible_server-userdata = <<USERDATA
#!/usr/bin/env bash
set -e
apt-get -qq update &>/dev/null
apt-get -y install ansible
apt-get install -y git
mkdir -p /home/ubuntu/ansible
apt-get install python3
apt-get -y install python3-pip
pip install boto3
sudo usermod -aG sudo ubuntu

cat << EOF > /etc/ansible/ansible.cfg
[defaults]
host_key_checking = False
remote_user = ubuntu
private_key_file = ../terraform/project_instance_key.pem
inventory = /home/ubuntu/ansible/inventory.aws_ec2.yml

[inventory]
enable_plugins = aws_ec2

[ssh_connection]
ssh_args = -F ./ssh.config -o StrictHostKeyChecking=no -o ControlMaster=auto -o ControlPersist=30m 
control_path = ~/.ssh/ansible-%%r@%%h:%%p
EOF

git clone https://github.com/lihilu/lihilu-kandula_project.git /home/ubuntu/ansible/


USERDATA
}