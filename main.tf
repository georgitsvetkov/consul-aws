provider "aws" {
  region = "eu-west-1"
}


variable "nodes" {
  default = ["consul-dc1", "client-dc1", "consul-dc2", "client-dc2"]
}

resource "aws_instance" "gtsvetkov-test" {

  for_each               = toset(var.nodes)
  ami                    = "ami-0bf84c42e04519c85"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  key_name               = "georgitsvetkov"
  user_data = data.template_file.user_data.rendered

    tags = {
      Name = "consul test"
    }
}

  data "template_file" "user_data" {
    template = file("${path.module}/user-data.sh")
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







#   # The Chef, Puppet, and Salt provisioners install, configure, and run the Chef, Puppet, and Salt clients, respectively, automatically on the server. This makes it easier to use configuration management tools instead of ad hoc scripts to config‐ ure your servers.
#   provisioner "remote-exec" {
#     inline = [
#       "#!/bin/bash",
#       "sudo yum install -y yum-utils",
#       "sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo",
#       "sudo yum -y install consul",
#       "sudo yum install consul-enterprise-1.8.3+ent-2.x86_64",
#       "curl -L https://func-e.io/install.sh | bash -s -- -b /usr/local/bin",
#       "export FUNC_E_PLATFORM=darwin/amd64",
#       "func-e use 1.18.3",
#       "sudo cp ~/.func-e/versions/1.18.3/bin/envoy /usr/local/bin/"
#     ]
#   }
#
#   connection {
#     type        = "ssh"
#     host        = self.public_ip
#     user        = "ec2-user"
#     private_key = "georgitsvetkov"
#   }
# }


# You can use User Data scripts with ASGs, ensuring that all servers in that ASG execute the script during boot, including servers launched due to an auto scaling or auto recovery event. Provisioners take effect only while Terraform is running and don’t work with ASGs at all.
# The User Data script can be seen in the EC2 Console (select an Instance, click Actions → Instance Settings → View/Change User Data) and you can find its execution log on the EC2 Instance itself (typically in /var/log/cloud-init*.log), both of which are useful for debugging, and neither of which is available with provisioners.
#  user_data = <<-EOF
#               #!/bin/bash
#               sudo yum install -y yum-utils
#               sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
#               sudo yum -y install consul
#               sudo yum install consul-enterprise-1.8.3+ent-2.x86_64
#               curl -L https://func-e.io/install.sh | bash -s -- -b /usr/local/bin
#               export FUNC_E_PLATFORM=darwin/amd64
#               func-e use 1.18.3
#               sudo cp ~/.func-e/versions/1.18.3/bin/envoy /usr/local/bin/
#               EOF
