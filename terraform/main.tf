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