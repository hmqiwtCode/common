variable "aws-region" {
  description = "Region AWS"
  type = string
  default = "us-east-1"
}

variable "instance" {
  description = "EC2 instance"
  type = string
  default = "t2.micro"
}