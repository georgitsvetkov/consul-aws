provider "aws" {
  region = "eu-west-1"
}


variable "nodes" {
  default = ["consul-dc1", "client-dc1", "consul-dc2", "client-dc2"]
}

resource "aws_instance" "gtsvetkov-test" {

  for_each = toset(var.nodes)
  ami                    = "ami-0bf84c42e04519c85"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  key_name               = "georgitsvetkov"

  user_data = <<-EOF
               #!/bin/bash
               sudo yum install -y yum-utils
               sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
               sudo yum -y install consul
               sudo yum install consul-enterprise-1.8.3+ent-2.x86_64
               curl -L https://func-e.io/install.sh | bash -s -- -b /usr/local/bin
               export FUNC_E_PLATFORM=darwin/amd64
               func-e use 1.18.3
               sudo cp ~/.func-e/versions/1.18.3/bin/envoy /usr/local/bin/
               EOF

  tags = {
    Name = "consul test"
  }

}

resource "aws_security_group" "instance" {
  name = "consul-test-instance"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

