# consul-cluster

## How to use this repo

- When you need to deploy 2 consul servers in separate datacenters (dc1 and dc2), you can use modules from this repo to spun up consul environment in AWS HC environment




This is a consul-cluster test TF config, which will be modifyed constantly till perfection. Additional comments and configs can be found in the TF files. 

The consul cluster contains two consul servers in separate DCs (dc1 and dc2) and two consul clients in each DC (dc1 and dc2).

- main.tf contains TF config for 4 AWS instances for eu-west-1 region
- iam.tf has the role/policy that is bieng created/assumed from the above instances 
- .sh files contain all user data related configuration for each consul host machine/server/client/dc
- outputs.tf has outputs with the ssh details (containing my local key-pair) for consul servers in dc1 and dc2

Remark: For this setup, I used default VPC, Subnet etc. AWS HC account settings, as well as Mac M1 with terraform v0.13.7 installed. The scripts and steps implemented above are being tested manually [by building infra using AWS console and final testing via TF](https://hashicorp.atlassian.net/wiki/spaces/GEOR/pages/2323157862/Spun+up+AWS+instance+via+AWS+Management+Console). Please also note that I'm using my own local key-pair for the TF outputs and connecting.

![Sample diagram](https://user-images.githubusercontent.com/100287834/160795699-15ca5577-8953-4f57-a4bc-c2fdabe9c7d1.png)


