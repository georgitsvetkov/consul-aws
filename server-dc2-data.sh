#!/usr/bin/env bash

curl --fail --silent --show-error --location https://apt.releases.hashicorp.com/gpg | \
      gpg --dearmor | \
      sudo dd of=/usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
 sudo tee -a /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update
sudo apt install net-tools
sudo apt-get install -y consul

cat > /var/tmp/consul.hcl << 'EOF'
datacenter = "dc2"
primary_datacenter= "dc1"
data_dir = "/opt/consul"
#bind_addr= "{{GetInterfaceIP \"eth0\"}}"
bootstrap_expect=1
server = true
advertise_addr = "{{GetInterfaceIP \"eth0\"}}"
advertise_addr_wan = "{{GetInterfaceIP \"eth0\"}}"
retry_join = ["provider=aws tag_key=Name tag_value=consul_client_dc2"]
retry_join_wan = ["provider=aws tag_key=Name tag_value=consul_server_dc1"]
connect {
  enabled = true
}
ports {
   grpc = 8502
}
EOF

cat > /var/tmp/consul-acl.hcl << 'EOF'
acl {
  enabled        = true
  default_policy = "allow"
  down_policy    = "extend-cache"
  enable_token_persistence = true
  enable_token_replication = true
}
EOF

sudo cp /var/tmp/consul-acl.hcl /etc/consul.d/consul-acl.hcl
sudo cp /var/tmp/consul.hcl /etc/consul.d/consul.hcl
sudo chown consul:consul /etc/consul.d/consul.hcl
sudo chown consul:consul /etc/consul.d/consul-acl.hcl

sudo systemctl start consul

consul members

consul members -wan
