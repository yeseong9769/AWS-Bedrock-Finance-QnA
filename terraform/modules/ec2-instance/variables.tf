variable "public_subnet_ids" {
    type = list(string)
}

variable "private_subnet_ids" {
    type = list(string)
}

variable "security_group_ids" {
    type = list(string)
}

variable "internal_lb_dns_name" {
    type = string
}