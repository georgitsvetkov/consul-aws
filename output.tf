output "SSH_Connection_Client_DC1" {
  value = format("ssh connection to instance consul_client_dc1 ==> ssh -i terraform-key-pair.pem ubuntu@%s", aws_instance.consul_client_dc1.public_ip)
}

output "SSH_Connection_Client_DC2" {
  value = format("ssh connection to instance consul_client_dc2 ==> ssh -i terraform-key-pair.pem ubuntu@%s", aws_instance.consul_client_dc2.public_ip)
}

output "SSH_Connection_Server_DC1" {
  value = format("ssh connection to instance consul_server_dc1 ==> ssh -i terraform-key-pair.pem ubuntu@%s", aws_instance.consul_server_dc1.public_ip)
}

output "SSH_Connection_Server_DC2" {
  value = format("ssh connection to instance consul_server_dc2 ==> ssh -i terraform-key-pair.pem ubuntu@%s", aws_instance.consul_server_dc2.public_ip)
}

output "ssh_key" {
  description = "ssh key generated by terraform"
  value       = tls_private_key.dev_key.private_key_pem
}
