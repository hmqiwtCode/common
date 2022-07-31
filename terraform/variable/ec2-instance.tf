terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.50.0"
    }
  }

  backend "s3" {
    bucket = "my-website-source-quyhm-prod"
    key = "tf"
    region = "us-east-1"
  }
}
provider "aws" {
  region = var.aws-region
}

resource "aws_instance" "TestTerraform" {
  ami           = "ami-0cff7528ff583bf9a"
  instance_type = var.instance
}

resource "aws_security_group" "backend_app" {
  name        = "backend_app_allowed_all_port"
  description = "Allow all inbound traffic"

  ingress {
    from_port = 0
    to_port = 0
    protocol = -1
    description      = "Allow all inbound traffic"
    cidr_blocks      = ["0.0.0.0/0"] 
  }

  tags = {
    Name = "Allow_PORT"
  }
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.backend_app.id
  network_interface_id = aws_instance.TestTerraform.primary_network_interface_id
}


output "instance_ip" {
  value = aws_instance.TestTerraform.public_ip
}
