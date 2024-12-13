project_name = "docuQuery"
region       = "ap-northeast-2"

vpc_cidr = "172.28.0.0/16"

# Security
allowed_ssh_cidr = "121.168.119.104/32"

# Instance types
instance_type = {
  bastion = "t3a.nano"
  web     = "t3a.micro"
  api     = "t3a.micro"
}

credentials_file = ".aws/credentials"