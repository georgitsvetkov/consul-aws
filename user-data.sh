#!/bin/bash

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install consul
sudo yum install consul-enterprise-1.8.3+ent-2.x86_64
curl -L https://func-e.io/install.sh | bash -s -- -b /usr/local/bin
export FUNC_E_PLATFORM=darwin/amd64
func-e use 1.18.3
sudo cp ~/.func-e/versions/1.18.3/bin/envoy /usr/local/bin/
