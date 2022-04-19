#!/usr/bin/env bash

curl --fail --silent --show-error --location https://apt.releases.hashicorp.com/gpg | \
      gpg --dearmor | \
      sudo dd of=/usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
 sudo tee -a /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update
sudo apt install net-tools
sudo apt-get install -y consul

sudo mkdir --parents /etc/consul.d
sudo touch /etc/consul.d/consul.hcl
sudo chown --recursive consul:consul /etc/consul.d
sudo chmod 640 /etc/consul.d/consul.hcl

cat > /var/tmp/consul.hcl << 'EOF'
datacenter = "dc2"
data_dir = "/opt/consul"
bind_addr= "{{GetInterfaceIP \"eth0\"}}"
retry_join = ["provider=aws tag_key=Name tag_value=consul_server_dc2"]
primary_datacenter= "dc1"
ports {
   grpc = 8502
}
acl {
  enabled = true
  default_policy = "allow"
  down_policy = "extend-cache"
  enable_token_persistence = true
  enable_token_replication = true
}
EOF

sudo cp /var/tmp/consul.hcl /etc/consul.d/consul.hcl
sudo chown consul:consul /etc/consul.d/consul.hcl

sudo systemctl start consul

consul members

sudo apt install unzip
sudo wget https://github.com/hashicorp/demo-consul-101/releases/download/0.0.3.1/dashboard-service_linux_amd64.zip -P /var/tmp/ 
cd /var/tmp/ && unzip dashboard-service_linux_amd64.zip

curl -L https://func-e.io/install.sh | sudo bash -s -- -b /usr/local/bin

func-e use 1.18.3

sudo cp ~/.func-e/versions/1.18.3/bin/envoy /usr/local/bin/

cat > /var/tmp/dashboard.hcl << 'EOF'
service {
  name = "dashboard"
  port = 9002

  connect {
    sidecar_service {
      proxy {
        upstreams = [
          {
            destination_name = "counting"
            local_bind_port  = 5000
          }
        ]
      }
    }
  }

  check {
    id       = "dashboard-check"
    http     = "http://localhost:9002/health"
    method   = "GET"
    interval = "1s"
    timeout  = "1s"
  }
}
EOF

consul services register dashboard.hcl

consul catalog services

cat > /var/tmp/intention-config.hcl << 'EOF'
Kind = "service-intentions"
Name = "counting"
Sources = [
  {
    Name   = "dashboard"
    Action = "allow"
  }
]
EOF

cd /var/tmp/

consul config write intention-config.hcl

PORT=9002 COUNTING_SERVICE_URL="http://localhost:5000" ./dashboard-service_linux_amd64 &

touch dashboard-proxy.log
sudo chmod ugo+rwx dashboard-proxy.log

consul connect envoy -sidecar-for dashboard > dashboard-proxy.log &

