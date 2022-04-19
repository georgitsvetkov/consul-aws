# consul-aws 

### Description 

This is a terraform code, that spuns up 4 AWS EC2 instances and bootstraps them with 2 consul servers in different datacenters and two consul clients in each respective datacenter.

![Sample diagram](https://user-images.githubusercontent.com/100287834/160795699-15ca5577-8953-4f57-a4bc-c2fdabe9c7d1.png)

### Summary

In order to set 4 instances and run two consul servers and two consul clients:
- I have included TF code that spuns up 4 EC2 AWS VMs and outputs consul servers EC2 login details
- I have included .sh scripts for each instance that will configure/install/start consul 

### How to use this repo

As a prerequisite, you need to have Terraform installed and functioning, AWS account setup and authenticated, so you can deploy resources to AWS via TF. TF version that is being used/tested with this repo is v0.13.7. 

Download/clone [this git repo files](https://github.com/georgitsvetkov/consul-cluster.git) on your machine
```
https://github.com/georgitsvetkov/consul-cluster.git
```

Open your machine CLI console and navigate to the location where you've downloaded the repo 
```
cd ./<repo location>
```

Initiate, plan and apply terraform 
```
terraform init
terraform plan
terraform apply followed by "yes"
```

Once TF is deployment is complete you will see `terraform-key-pair.pem` in that same location that you've downloaded the repo and initiated terraform
Sample output:
```
aws_key_pair.generated_key: Creation complete after 0s [id=terraform-key-pair]
```

At a successfull TF deployment, you should get an output, `SSH_Connection_Client/Server_DC1` and `SSH_Connection_Client/Server_DC2`, which has the SSH login commands containig .pem private key
```
aws_instance.consul_server_dc1: Creation complete after 43s [id=i-0148e4a2eaf6f5b03]

Apply complete! Resources: 11 added, 0 changed, 0 destroyed.

Outputs:

SSH_Connection_Client_DC1 = ssh connection to instance consul_server_dc2 ==> sudo ssh -i terraform-key-pair.pem ubuntu@63.32.93.215
SSH_Connection_Client_DC2 = ssh connection to instance consul_server_dc2 ==> sudo ssh -i terraform-key-pair.pem ubuntu@54.75.47.82
```

In order to login to the consul_client_dc1/2, use the output from the commands above (Please note that terraform-key-pair.pem should be in the same location/folder, otherwise you might need to specify path to the key)
```
sudo ssh -i terraform-key-pair.pem ubuntu@<public_ip>
```

Verify that consul members, consul services and consul service checks are there (you should see one consul server and one client in each respective dc1/2)
```
consul members
consul catalog services
curl -X GET 'localhost:8500/v1/health/state/:state'
```

Verify that services are up and running using Consul UI:

- Connect to the Consul Server DC1 using Terminal and make a port redirect to localhost, using the public ip of the EC2 instance of the consul server DC1:
```
ssh -R 127.0.0.1:8500:127.0.0.1:8500 ubuntu@<Consul_ServerDC1_EC2_PUBLIC_IP> -i "terraform-key-pair"
```

- Connect to Consul UI, using your browser:
```
http://<Consul_ServerDC1_EC2_PUBLIC_IP>:8500/ui/
```

- Navigate to "Services" tab and ensure that counting service checks are passing successfully

Once done, ensure that you detroy the whole infra that you've created for a test:
```
terraform init
terraform destroy -> yes
```

Remark: For this setup, I used default VPC, Subnet etc. AWS HC account settings, as well as Mac M1 with terraform v0.13.7 installed. The scripts and steps implemented above are being tested manually [by building infra using AWS console and final testing via TF](https://hashicorp.atlassian.net/wiki/spaces/GEOR/pages/2323157862/Spun+up+AWS+instance+via+AWS+Management+Console).


