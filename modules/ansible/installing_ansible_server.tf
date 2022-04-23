locals {
 ansible_server-userdata = <<USERDATA
#!/usr/bin/env bash
set -e
apt-get -qq update &>/dev/null
apt install -Y ansible
mkdir ~/ansible
apt install python3
apt -Y install python3-pip
pip install boto3
sudo usermod -aG sudo ubuntu


cat << EODMCF >/etc/ansible/ansible.cfg
[defaults]
host_key_checking = False
remote_user = ubuntu
private_key_file = ../terraform/project_instance_key.pem
inventory = ~/ansible/inventory.aws_ec2.yml

[inventory]
enable_plugins = aws_ec2

[ssh_connection]
ssh_args = -F ./ansible.ssh.config -o StrictHostKeyChecking=no -o ControlMaster=auto -o ControlPersist=30m 
control_path = ~/.ssh/ansible-%%r@%%h:%%p
EODMCF



USERDATA
 }