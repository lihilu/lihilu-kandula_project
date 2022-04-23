locals {
 consul_server-userdata = <<USERDATA
#!/usr/bin/env bash
set -e
### set consul version
CONSUL_VERSION=${var.consul_version}
echo "Grabbing IPs..."
PRIVATE_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
echo "Installing dependencies..."
apt-get -qq update &>/dev/null
apt-get -qqy install zip unzip
apt-get -qq install dnsmasq
echo "Configuring dnsmasq..."
cat << EODMCF >/etc/dnsmasq.d/10-consul
# Enable forward lookup of the 'consul' domain:
server=/consul/127.0.0.1#8600
EODMCF
systemctl restart dnsmasq
cat << EOF >/etc/systemd/resolved.conf
[Resolve]
DNS=127.0.0.1
Domains=~consul
EOF
systemctl restart systemd-resolved.service
echo "Fetching Consul..."
cd /tmp
curl -sLo consul.zip https://releases.hashicorp.com/consul/${var.consul_version}/consul_${var.consul_version}_linux_amd64.zip
echo "Installing Consul..."
unzip consul.zip >/dev/null
sudo chmod +x consul
sudo mv consul /usr/local/bin/consul
# Setup Consul
mkdir -p /opt/consul
mkdir -p /etc/consul.d
mkdir -p /run/consul
tee /etc/consul.d/config.json > /dev/null <<EOF
{
  "advertise_addr": "$PRIVATE_IP",
  "bind_addr": "$PRIVATE_IP",
  "data_dir": "/opt/consul",
  "datacenter": "opsschool-Lihi",
  "encrypt": "uDBV4e+LbFW3019YKPxIrg==",
  "disable_remote_exec": true,
  "disable_update_check": true,
  "leave_on_terminate": true,
  "retry_join": ["provider=aws tag_key=${var.consul_join_tag_key} tag_value=${var.consul_join_tag_value}"],
  "server": true,
  "bootstrap_expect": 3,
  "ui": true,
  "client_addr": "0.0.0.0",
  "retry_interval": "15s"
}
EOF
# Create user & grant ownership of folders
useradd consul
chown -R consul:consul /opt/consul /etc/consul.d /run/consul
# Configure consul service
tee /etc/systemd/system/consul.service > /dev/null <<"EOF"
[Unit]
Description=Consul service discovery server
Requires=network-online.target
After=network.target
[Service]
User=consul
Group=consul
Restart=on-failure
Environment=GOMAXPROCS=2
ExecStartPre=+/bin/mkdir -p /run/consul
ExecStartPre=+/bin/chown consul:consul /run/consul
ExecStart=/usr/local/bin/consul agent -pid-file=/run/consul/consul.pid -config-dir=/etc/consul.d
ExecReload=/bin/kill -s HUP $MAINPID
KillSignal=SIGINT
TimeoutStopSec=5
ExecStartPre=+/bin/mkdir -p /run/consul
ExecStartPre=+/bin/chown consul:consul /run/consul
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable consul.service
systemctl start consul.service
exit 0
USERDATA


 consul_agent-userdata = <<USERDATA
#!/usr/bin/env bash
set -e
### set consul version
CONSUL_VERSION=${var.consul_version}
echo "Grabbing IPs..."
PRIVATE_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
echo "Installing dependencies..."
apt-get -qq update &>/dev/null
apt-get -yqq install nginx 
apt-get -qqy install zip unzip
apt-get -qq install dnsmasq
echo "Configuring dnsmasq..."
cat << EODMCF >/etc/dnsmasq.d/10-consul
# Enable forward lookup of the 'consul' domain:
server=/consul/127.0.0.1#8600
EODMCF
systemctl restart dnsmasq
cat << EOF >/etc/systemd/resolved.conf
[Resolve]
DNS=127.0.0.1
Domains=~consul
EOF
systemctl restart systemd-resolved.service
echo "Fetching Consul..."
cd /tmp
curl -sLo consul.zip https://releases.hashicorp.com/consul/${var.consul_version}/consul_${var.consul_version}_linux_amd64.zip
echo "Installing Consul..."
unzip consul.zip >/dev/null
chmod +x consul
mv consul /usr/local/bin/consul
# Setup Consul
mkdir -p /opt/consul
mkdir -p /etc/consul.d
mkdir -p /run/consul
tee /etc/consul.d/config.json > /dev/null <<EOF
{
  "bind_addr": "$PRIVATE_IP",
  "advertise_addr": "$PRIVATE_IP",
  "data_dir": "/opt/consul",
  "datacenter": "opsschool-Lihi",
  "encrypt": "uDBV4e+LbFW3019YKPxIrg==",
  "disable_remote_exec": true,
  "disable_update_check": true,
  "leave_on_terminate": true,
  "retry_join": ["provider=aws tag_key=${var.consul_join_tag_key} tag_value=${var.consul_join_tag_value}"],
  "enable_script_checks": true,
  "server": false,
  "retry_interval": "15s"
}
EOF
tee /etc/consul.d/web.json > /dev/null <<EOF
{
  "service": {
    "name": "webserver",
    "tags": [
      "webserver"
    ],
    "port": 80,
    "check": {
      "args": [
        "curl",
        "localhost"
      ],
      "interval": "10s"
    }
  }
}
EOF
# Create user & grant ownership of folders
useradd consul
chown -R consul:consul /opt/consul /etc/consul.d /run/consul
# Configure consul service
tee /etc/systemd/system/consul.service > /dev/null <<"EOF"
[Unit]
Description=Consul service discovery agent
Requires=network-online.target
After=network.target
[Service]
User=consul
Group=consul
Restart=on-failure
Environment=GOMAXPROCS=2
ExecStartPre=+/bin/mkdir -p /run/consul
ExecStartPre=+/bin/chown consul:consul /run/consul
ExecStart=/usr/local/bin/consul agent -pid-file=/run/consul/consul.pid -config-dir=/etc/consul.d
ExecReload=/bin/kill -s HUP $MAINPID
KillSignal=SIGINT
TimeoutStopSec=5
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable consul.service
systemctl start consul.service
systemctl restart nginx
exit 0
USERDATA
}
