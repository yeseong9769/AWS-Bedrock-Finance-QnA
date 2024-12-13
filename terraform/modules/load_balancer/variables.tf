variable "vpc_id" {
  description = "The ID of the VPC"
  type = string
}

variable "security_group_ids" {
  description = "The IDs of the security groups"
  type = list(string)
}

variable "target_id" {
  description = "The ID of the target"
  type = list(string)
}

variable "public_subnet_ids" {
    type = list(string)
}

variable "private_subnet_ids" {
    type = list(string)
}