# consul-cluster setup repo

This is a consul-cluster test TF config, which will be modifyed constantly till perfection. Additional comments and configs can be found in the TF files. 

The consul cluster contains two consul servers in separate DCs (dc1 and dc2) and two consul clients in each DC (dc1 and dc2).

- main.tf contains TF config for 4 AWS instances for eu-west-1 region
- iam.tf has the role/policy that is bieng created/assumed from the above instances 
- .sh files contain all user data related configuration for each consul host machine/server/client/dc
- outputs.tf has outputs with the ssh details (containing my local key-pair) for consul servers in dc1 and dc2

Remark: For this setup, I used default VPC, Subnet etc. AWS HC account settings, as well as Mac M1 with terraform v0.13.7 installed. The scripts and steps implemented above are being tested manually [by building infra using AWS console and final testing via TF](https://hashicorp.atlassian.net/wiki/spaces/GEOR/pages/2323157862/Spun+up+AWS+instance+via+AWS+Management+Console). Please also note that I'm using my own local key-pair for the TF outputs and connecting.

![Sample diagram](https://user-images.githubusercontent.com/100287834/160795699-15ca5577-8953-4f57-a4bc-c2fdabe9c7d1.png)

## How to use this repo

As a prerequisite, you need to have Terraform installed and functioning, AWS account setup and authenticated, so you can deploy resources to AWS via TF. TF version that is being used/tested with this repo is v0.13.7. 

What?
- When you need to deploy 2 consul servers in separate datacenters (dc1 and dc2), with 2 consul clients one in each datacenter, you can use modules from this repo to quickly spun up consul cluster in AWS HC environment.

How?
- Download/clone [this git repo files](https://github.com/georgitsvetkov/consul-cluster.git) on your machine
- Open your machine CLI console and navigate to the location where you've downloaded the repo `cd ./<repo location>`
- Initiate `terraform init`, followed by `terraform plan` and `terraform apply`
- You will see terraform deploying resources and creating `terraform-key-pair.pem` in that same location that you've downloaded the repo and initiated terraform
- As a successfull TF deployment, you should get an output, `SSH_Connection_Client_DC1` and `SSH_Connection_Client_DC2`, which has the SSH login commands containig .pem private key, instance uname and public ip `sudo ssh -i terraform-key-pair.pem ubuntu@<public_ip>`
- Once logged in to the EC2 consul client dc1/2 instance, verify that consul members are there `consul members` (you should see one consul server and one client in each respective dc1/2)
- In order to test that consul_client_dc1 is able to communicate with consul_client_dc2, use consul KV, as follows:
consul_client_dc1 - set KV on consul_client_dc1 to 5 and verify that is being recorded:
```
consul kv put config/redis/maxconns 5
consul kv get config/redis/maxconns
```
consul_client_dc2 - change KV on consul_client_dc1 from 5 to 10 and verify that the change is being successfull:
```
consul kv put -datacenter=dc1 config/redis/maxconns 10
consul kv get -datacenter=dc1 config/redis/maxconns
```



