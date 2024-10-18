# Input variable definitions

variable "vpc_name" {
  description = "Name of VPC"
  type        = string
  default     = "development-vpc"
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
