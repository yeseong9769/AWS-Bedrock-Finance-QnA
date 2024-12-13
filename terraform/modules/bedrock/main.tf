resource "aws_bedrockagent_data_source" "this" {
#   provider = aws.bedrock
  knowledge_base_id = aws_bedrockagent_knowledge_base.this.id
  name              = "knowledge-base-d9gcy-data-source"
  data_source_configuration {
    type = "S3"
    s3_configuration {
      bucket_arn = "arn:aws:s3:::knowledge-base-quick-start-d9gcy-s3-bucket"
    }
  }
}

resource "aws_bedrockagent_knowledge_base" "this" {
#   provider = aws.bedrock
  name     = "knowledge-base-d9gcy"
  
  role_arn = "arn:aws:iam::372077705593:role/service-role/AmazonBedrockExecutionRoleForKnowledgeBase_d9gcy"
  knowledge_base_configuration {
    vector_knowledge_base_configuration {
      embedding_model_arn = "arn:aws:bedrock:us-east-1::foundation-model/amazon.titan-embed-text-v2:0"
    }
    type = "VECTOR"
  }
  storage_configuration {
    type = "PINECONE"
    pinecone_configuration {
      connection_string = "https://knowledge-base-d9gcy-vector-db-m0f5nhk.svc.aped-4627-b74a.pinecone.io"
      credentials_secret_arn = "arn:aws:secretsmanager:us-east-1:372077705593:secret:dev/DocuQuery-ebrCK6"
      field_mapping {
        metadata_field = "메타데이터"
        text_field = "텍스트"
      }
    }
  }
}