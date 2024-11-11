# provider "aws" {
#   region                   = "us-east-1"
#   shared_credentials_files = [".aws/credentials"]
# }

# resource "aws_vpc" "bedrock_vpc" {
#   cidr_block           = "172.32.0.0/16"
#   instance_tenancy    = "default"

#   tags = {
#     Name = "bedrock-vpc"
#   }
# }

# resource "aws_vpc_attribute" "enable_dns_hostnames" {
#   vpc_id = aws_vpc.bedrock_vpc.id
#   enable_dns_hostnames = true
# }

# resource "aws_subnet" "bedrock_subnet_private1" {
#   vpc_id            = aws_vpc.bedrock_vpc.id
#   cidr_block        = "172.32.128.0/20"
#   availability_zone = "us-east-1a"

#   tags = {
#     Name = "bedrock-subnet-private1-us-east-1a"
#   }
# }

# resource "aws_route_table" "bedrock_rtb_private1" {
#   vpc_id = aws_vpc.bedrock_vpc.id

#   tags = {
#     Name = "bedrock-rtb-private1-us-east-1a"
#   }
# }

# resource "aws_route_table_association" "bedrock_subnet_private1" {
#   subnet_id      = aws_subnet.bedrock_subnet_private1.id
#   route_table_id = aws_route_table.bedrock_rtb_private1.id
# }

# resource "aws_vpc_endpoint" "bedrock_vpc_endpoint" {
#   vpc_id       = aws_vpc.bedrock_vpc.id
#   service_name = "com.amazonaws.us-east-1.bedrock-runtime"
# }

# resource "aws_bedrockagent_knowledge_base" "doquQuery-knowledge-base" {
#   name     = "doquQuery-knowledge-base"
#   role_arn = aws_iam_role.example.arn
#   knowledge_base_configuration {
#     vector_knowledge_base_configuration {
#       embedding_model_arn = "arn:aws:bedrock:us-west-2::foundation-model/amazon.titan-embed-text-v1"
#     }
#     type = "VECTOR"
#   }
#   storage_configuration {
#     type = "OPENSEARCH_SERVERLESS"
#     opensearch_serverless_configuration {
#       collection_arn    = "arn:aws:aoss:us-west-2:123456789012:collection/142bezjddq707i5stcrf"
#       vector_index_name = "bedrock-knowledge-base-default-index"
#       field_mapping {
#         vector_field   = "bedrock-knowledge-base-default-vector"
#         text_field     = "AMAZON_BEDROCK_TEXT_CHUNK"
#         metadata_field = "AMAZON_BEDROCK_METADATA"
#       }
#     }
#   }
# }