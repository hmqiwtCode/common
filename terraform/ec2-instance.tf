terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.50.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "TestTerraform" {
  ami           = "ami-0cff7528ff583bf9a"
  instance_type = "t2.micro"
}

output "instance_ip" {
  value = aws_instance.TestTerraform.public_ip
}
