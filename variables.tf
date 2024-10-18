# Input variable definitions

variable "vpc_id" {
  description = "Where to deploy"
  type        = string
  default     = "vpc-0ea1fb5e7fb5fd725"
}

variable "instance_name" {
  description = "Name of VM"
  type        = string
  default     = "development-VM"
}

variable "num_nodes" {
  description = "number of application nodes"
  type        = string
  default     = "1"
}

variable "subnet_id" {
  description = "ID of subnet to connect to"
  type        = string
  default     = "subnet-0bd9635127b86b2c4"
}

variable "security_group_id" {
  description = "ID of security group to use"
  type        = string
  default     = "sg-0e3d71fa803d5f91e"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "development"
}