variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-northeast-2"
}

variable "credentials_file" {
  description = "Path to AWS credentials file"
  type        = string
  default     = ".aws/credentials"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "172.28.0.0/16"
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed for SSH access to bastion host"
  type        = string
  default     = "121.168.119.104/32"
}

variable "instance_type" {
  description = "EC2 instance types"
  type = object({
    bastion = string
    web     = string
    api     = string
  })
  default = {
    bastion = "t3a.nano"
    web     = "t3a.micro"
    api     = "t3a.micro"
  }
}