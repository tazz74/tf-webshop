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

# Create a Security Group for an EC2 instance
resource "aws_security_group" "webshop_sg" {
  name = "${var.environment}-webshop_sg"
  
  ingress {
    from_port	  = 8080
    to_port	  = 8080
    protocol	  = "tcp"
    cidr_blocks	= ["0.0.0.0/0"]
  }
  ingress {
    from_port	  = 443
    to_port	  = 443
    protocol	  = "tcp"
    cidr_blocks	= ["0.0.0.0/0"]
  }
}

resource "aws_instance" "Webshop" {
  ami = "ami-0745b7d4092315796"
  instance_type = "t2.micro"
  count = var.num_nodes
  #subnet_id = var.subnet_id
  vpc_security_group_ids  = ["${aws_security_group.webshop_sg.id}"]
  associate_public_ip_address = true

  user_data = <<-EOF
      #!/bin/bash
      echo "<hmtl><body><h1>I've been provisioned using HashiCorp Terraform Cloud!</h1></body></html>" > index.html
      nohup busybox httpd -f -p 8080 &
      EOF
  
  tags = {
    Name = var.instance_name
    Environment = var.environment
  }
}

# Output variable: Public IP address
output "public_ip_0" {
  value = "${aws_instance.Webshop[0].public_ip}"
}
output "public_ip_1" {
  value = "${aws_instance.Webshop[1].public_ip}"
}