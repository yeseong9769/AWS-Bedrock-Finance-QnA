terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region                   = "ap-northeast-2"
  shared_credentials_files = [".aws/credentials"]
}

provider "aws" {
  alias                    = "bedrock"
  region                   = "us-east-1"
  shared_credentials_files = [".aws/credentials"]
}

module "ap-northeast-2" {
  source = "./ap-northeast-2"
}

module "us-east-1" {
  source = "./us-east-1"
}