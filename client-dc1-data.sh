#!/usr/bin/env bash

curl --fail --silent --show-error --location https://apt.releases.hashicorp.com/gpg | \
      gpg --dearmor | \
      sudo dd of=/usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
 sudo tee -a /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update
sudo apt install net-tools
sudo apt-get install -y consul-enterprise=1.8.3+ent

sudo mkdir --parents /etc/consul.d
sudo touch /etc/consul.d/consul.hcl
sudo chown --recursive consul:consul /etc/consul.d
sudo chmod 640 /etc/consul.d/consul.hcl

cat > /var/tmp/consul.hcl << 'EOF'
datacenter = "dc1"
data_dir = "/opt/consul"
#bind_addr= "{{GetInterfaceIP \"eth0\"}}"
retry_join = ["provider=aws tag_key=Name tag_value=consul_server_dc1"]
EOF

sudo cp /var/tmp/consul.hcl /etc/consul.d/consul.hcl
sudo chown consul:consul /etc/consul.d/consul.hcl

sudo systemctl start consul

consul members
