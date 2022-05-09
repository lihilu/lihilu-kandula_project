locals {
  jenkins_server_userdata = <<USERDATA
#!/usr/bin/env bash
set -e

sudo hostnamectl set-hostname jenkins_server
USERDATA
}

locals {
  jenkins_agent_userdata = <<USERDATA
#!/usr/bin/env bash
set -e

sudo hostnamectl set-hostname jenkins_agent
USERDATA
}