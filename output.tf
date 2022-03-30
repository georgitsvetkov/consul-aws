# source code - https://github.com/brokedba/terraform-examples/blob/master/terraform-provider-aws/launch-instance/outputs.tf

output "SSH_Connection_Server_DC1" {
     value      = format("ssh connection to instance consul_server_dc1 ==> sudo ssh -i "georgitsvetkov.pem" ubuntu@%s",aws_instance.consul_server_dc1.public_ip)
}

output "SSH_Connection_Server_DC2" {
     value      = format("ssh connection to instance consul_server_dc2 ==> sudo ssh -i "georgitsvetkov.pem" ubuntu@%s",aws_instance.consul_server_dc2.public_ip)
}
