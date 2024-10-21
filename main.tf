variable "AWS_ACCESS_KEY_ID" {}
variable "AWS_SECRET_ACCESS_KEY" {}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.72.0"
    }
  }
}

provider "aws" {
  region  = "eu-central-1"
}

resource "aws_instance" "Webshop" {
  ami = "ami-0084a47cc718c111a"
  instance_type = "t2.micro"
  count = var.num_nodes
  subnet_id = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  associate_public_ip_address = true

  user_data = <<-EOF
  #!/bin/bash
  apt -y update
  apt -y install apache2
  ufw allow 'Apache'
  echo "<html><h1>I've been provisioned using HasiCorp Terraform Cloud!</h1></html>" > /var/www/html/index.html
  systemctl start apache2
  EOF
  
  tags = {
    Name = var.instance_name
  }
}
