terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                   = var.region
  shared_credentials_files = [var.credentials_file]
}

provider "aws" {
  alias                    = "bedrock"
  region                   = "us-east-1"
  shared_credentials_files = [var.credentials_file]
}

module "network" {
  source = "./modules/network"
}

module "ec2-instance" {
  source             = "./modules/ec2-instance"
  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids

  security_group_ids = [
    module.network.bastion_host_sg_id,
    module.network.web_server_sg_id,
    module.network.api_server_sg_id
  ]

  internal_lb_dns_name = module.load_balancer.internal_lb_dns_name
}

module "load_balancer" {
  source = "./modules/load_balancer"
  vpc_id = module.network.vpc_id

  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids

  security_group_ids = [
    module.network.web_server_lb_sg_id,
    module.network.api_server_lb_sg_id
  ]

  target_id = [
    module.ec2-instance.web_server_1_id,
    module.ec2-instance.web_server_2_id,
    module.ec2-instance.api_server_1_id,
    module.ec2-instance.api_server_2_id
  ]
}

module "bedrock" {
  source = "./modules/bedrock"
}