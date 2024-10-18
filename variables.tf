# Input variable definitions

variable "instance_name" {
  description = "Name of VM"
  type        = string
  default     = "development-VM"
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
