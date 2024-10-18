terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.72.1"
    }
  }
}

provider "aws" {
  region  = "eu-central-1"
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    Name = "Public"
  }
}

resource "aws_security_group" "webshop_ext_access" {
    name        = "webshop_ext_access"
    description = "Allow incoming HTTP/HTTPS connections"
    
    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
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
  echo "<html><h1>webpage 1(I've been provisioned using HasiCorp Terraform!)</h1></html>" > /var/www/html/index.html
  systemctl start apache2
  EOF
  
  tags = {
    Name = var.instance_name
  }
}

resource "aws_lb" "webshop-lb" {
    name            = "webshop-alb"
    internal        = false
    ip_address_type     = "ipv4"
    load_balancer_type = "application"
    security_groups = [aws_security_group.webshop_ext_access.id]
    
    for_each      = toset(data.aws_subnets.public.ids)
    subnets       = each.value
    
    tags = {
        Name = "webshop-alb"
        Environment = var.environment
    }
}

resource "aws_lb_target_group" "target-group" {
    health_check {
        interval            = 10
        path                = "/"
        protocol            = "HTTPS"
        timeout             = 5
        healthy_threshold   = 5
        unhealthy_threshold = 2
    }
    name          = "webshop-tg"
    port          = 443
    protocol      = "HTTPS"
    target_type   = "instance"
    vpc_id = var.vpc_id
}

resource "aws_lb_listener" "alb-listener" {
    load_balancer_arn          = aws_lb.webshop-lb.arn
    port                       = 443
    protocol                   = "HTTPS"
    default_action {
        target_group_arn         = aws_lb_target_group.target-group.arn
        type                     = "forward"
    }
}

resource "aws_lb_target_group_attachment" "ec2_attach" {
    count = length(aws_instance.Webshop)
    target_group_arn = aws_lb_target_group.target-group.arn
    target_id        = aws_instance.Webshop[count.index].id
}