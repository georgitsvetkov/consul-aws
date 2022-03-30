provider "aws" {
  region = "eu-west-1"
}

# Servers instances config

# variable "consul_server" {
#   default = ["consul1-dc1"]
# }

#Server DC1

resource "aws_instance" "consul_server_dc1" {

  # for_each               = toset(var.consul_server)
  ami                    = "ami-08ca3fed11864d6bb"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  key_name               = "georgitsvetkov"
  user_data              = data.template_file.server_data1.rendered
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name

  tags = {
    Name = "consul_server_dc1"
  }
}

data "template_file" "server_data1" {
  template = file("${path.module}/server-dc1-data.sh")
}

# Server DC2

resource "aws_instance" "consul_server_dc2" {

  # for_each               = toset(var.consul_server)
  ami                    = "ami-08ca3fed11864d6bb"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  key_name               = "georgitsvetkov"
  user_data              = data.template_file.server_data2.rendered
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name

  tags = {
    Name = "consul_server_dc2"
  }
}

data "template_file" "server_data2" {
  template = file("${path.module}/server-dc2-data.sh")
}


# Clients instances config

# variable "consul_client" {
#   default = ["client1-dc1"]
# }

resource "aws_instance" "consul_client_dc1" {

  #for_each               = toset(var.consul_client)
  ami                    = "ami-08ca3fed11864d6bb"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  key_name               = "georgitsvetkov"
  user_data              = data.template_file.client_data1.rendered
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name


  tags = {
    Name = "consul_client_dc1"
  }
}

data "template_file" "client_data1" {
  template = file("${path.module}/client-dc1-data.sh")
}

# Client DC2

resource "aws_instance" "consul_client_dc2" {

  #for_each               = toset(var.consul_client)
  ami                    = "ami-08ca3fed11864d6bb"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  key_name               = "georgitsvetkov"
  user_data              = data.template_file.client_data2.rendered
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name


  tags = {
    Name = "consul_client_dc2"
  }
}

data "template_file" "client_data2" {
  template = file("${path.module}/client-dc2-data.sh")
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

