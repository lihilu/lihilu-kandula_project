locals {
jenkins_home = "/home/ubuntu/jenkins_home"
jenkins_home_mount = "${local.jenkins_home}:/var/jenkins_home"
java_opts = "JAVA_OPTS='-Djenkins.install.runSetupWizard=false'"
jenkins_server_userdata = <<USERDATA
#!/usr/bin/env bash
set -e

sudo hostnamectl set-hostname jenkins_server

sudo chmod 666 /var/run/docker.sock

USERDATA



jenkins_agent_userdata = <<USERDATA
#!/usr/bin/env bash
set -e

sudo chmod 666 /var/run/docker.sock

USERDATA
}