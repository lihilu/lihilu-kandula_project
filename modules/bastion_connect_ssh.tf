
locals {
 bastion_connect_ssh = <<USERDATA
#!/bin/bash
eval "$(ssh-agent -s)"
ssh-add project_instance_key.pem
PUBLIC_IP=$(curl https://ipecho.net/plain ; echo)

cat << EOF > ../ansible/ssh.config
Host bastion
  Hostname $PUBLIC_IP
  User ubuntu
  IdentityFile ../terraform/project_instance_key.pem

Host 10.0.*.*
  User ubuntu
  IdentityFile ../terraform/project_instance_key.pem
  ProxyJump bastion
  StrictHostKeyChecking no
EOF

 USERDATA
}