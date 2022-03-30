# consul-cluster

This is a consul-cluster test TF config, which will be modifyed constantly till perfection. Additional comments and configs can be found in the TF files. 

The consul cluster contains two consul servers in separate DCs (dc1 and dc2) and two consul clients in each DC (dc1 and dc2).

- main.tf contains TF config for 4 AWS instances for eu-west-1 region
- iam.tf has the role/policy that is bieng created/assumed from the above instances 
- .sh files contain all user data related configuration for each consul host machine/server/client/dc
- outputs.tf has outputs with the ssh details for consul servers in dc1 and dc2

Remark: For this setup, I used default VPC, Subnet etc. AWS HC account settings, as well as Mac M1 with terraform v0.13.7 installed. The scripts and steps implemented above are being tested manually [by building infra using AWS console and final testing via TF](https://hashicorp.atlassian.net/wiki/spaces/GEOR/pages/2323157862/Spun+up+AWS+instance+via+AWS+Management+Console). 


![Sample Diagram](https://prnt.sc/c6FEgWTuq8cO)
