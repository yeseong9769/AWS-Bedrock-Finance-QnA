resource "aws_iam_role" "api_server_role" {
  name = "api-server-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "bedrock_policy" {
  name        = "bedrock-policy"
  description = "Policy to allow Bedrock service calls"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "bedrock:InvokeModel",
          "bedrock:InvokeModelWithResponseStream"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "bedrock_policy_attachment" {
  role       = aws_iam_role.api_server_role.name
  policy_arn = aws_iam_policy.bedrock_policy.arn
}

resource "aws_iam_instance_profile" "api_server_profile" {
  name = "api-server-profile"
  role = aws_iam_role.api_server_role.name
}