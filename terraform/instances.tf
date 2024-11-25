#################### Key Pair ####################
resource "tls_private_key" "rsa-4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2-key-pair" {
  key_name   = "ec2-key-pair"
  public_key = tls_private_key.rsa-4096.public_key_openssh
}

resource "local_sensitive_file" "ec2-private-key" {
  depends_on      = [aws_key_pair.ec2-key-pair]
  content         = tls_private_key.rsa-4096.private_key_pem
  filename        = "/home/sysoper/.ssh/id_rsa"
  file_permission = "0600"
}

#################### Bastion Host ####################
resource "aws_instance" "bastion_host" {
  ami                         = "ami-0de20b1c8590e09c5"
  instance_type               = "t3a.nano"
  subnet_id                   = aws_subnet.docuQuery_subnet_public2.id
  vpc_security_group_ids      = [aws_security_group.bastion_host_sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ec2-key-pair.key_name

  tags = {
    Name = "docuQuery-bastion-host"
  }
}

#################### Web Server ####################
resource "aws_instance" "web_server_1" {
  ami                         = "ami-0a027398380af6970"
  instance_type               = "t3a.micro"
  subnet_id                   = aws_subnet.docuQuery_subnet_private1.id
  vpc_security_group_ids      = [aws_security_group.web_server_sg.id]
  associate_public_ip_address = false
  key_name                    = aws_key_pair.ec2-key-pair.key_name
  user_data                   = <<-EOL
  #!/bin/bash -xe

  apt update
  apt install -y git python3-pip python3-venv
  mkdir /app
  cd /app
  git clone https://github.com/yeseong9769/AWS-Bedrock-Finance-QnA.git
  mv /app/AWS-Bedrock-Finance-QnA /app/docuQuery
  cd /app/docuQuery
  python3 -m venv /app/venv
  source /app/venv/bin/activate
  pip install -r /app/docuQuery/frontend/requirements.txt
  mkdir /app/docuQuery/frontend/.streamlit
  touch /app/docuQuery/frontend/.streamlit/secrets.toml
  echo "BACKEND_URL = \"http://${aws_lb.internal_lb.dns_name}:8000\"" > /app/docuQuery/frontend/.streamlit/secrets.toml
  cd /app/docuQuery/frontend
  streamlit run main.py --server.port 8080 --logger.level=warning &> streamlit.log &
  EOL

  tags = {
    Name = "docuQuery-web-server-1"
  }
}

resource "aws_instance" "web_server_2" {
  ami                         = "ami-0a027398380af6970"
  instance_type               = "t3a.micro"
  subnet_id                   = aws_subnet.docuQuery_subnet_private2.id
  vpc_security_group_ids      = [aws_security_group.web_server_sg.id]
  associate_public_ip_address = false
  key_name                    = aws_key_pair.ec2-key-pair.key_name
  user_data                   = <<-EOL
  #!/bin/bash -xe

  apt update
  apt install -y git python3-pip python3-venv
  mkdir /app
  cd /app
  git clone https://github.com/yeseong9769/AWS-Bedrock-Finance-QnA.git
  mv /app/AWS-Bedrock-Finance-QnA /app/docuQuery
  cd /app/docuQuery
  python3 -m venv /app/venv
  source /app/venv/bin/activate
  pip install -r /app/docuQuery/frontend/requirements.txt
  mkdir /app/docuQuery/frontend/.streamlit
  touch /app/docuQuery/frontend/.streamlit/secrets.toml
  echo "BACKEND_URL = \"http://${aws_lb.internal_lb.dns_name}:8000\"" > /app/docuQuery/frontend/.streamlit/secrets.toml
  cd /app/docuQuery/frontend
  streamlit run main.py --server.port 8080 --logger.level=warning &> streamlit.log &
  EOL

  tags = {
    Name = "docuQuery-web-server-2"
  }
}

resource "aws_iam_role" "bedrock_access_role" {
  name = "bedrock-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "bedrock_access" {
  name = "bedrock-access-policy"
  role = aws_iam_role.bedrock_access_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "bedrock:InvokeModel",
          "bedrock:ListFoundationModels",
          "bedrock:Retrieve"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "bedrock_access_profile" {
  name = "bedrock-access-instance-profile"
  role = aws_iam_role.bedrock_access_role.name
}

#################### API Server ####################
resource "aws_instance" "api_server_1" {
  ami                         = "ami-0de20b1c8590e09c5"
  instance_type               = "t3a.micro"
  subnet_id                   = aws_subnet.docuQuery_subnet_private3.id
  vpc_security_group_ids      = [aws_security_group.api_server_sg.id]
  associate_public_ip_address = false
  key_name                    = aws_key_pair.ec2-key-pair.key_name
  iam_instance_profile        = aws_iam_instance_profile.bedrock_access_profile.name
  user_data                   = <<-EOL
  #!/bin/bash -xe

  yum update -y
  yum install -y git python3-pip
  mkdir /app
  cd /app
  git clone https://github.com/yeseong9769/AWS-Bedrock-Finance-QnA.git
  mv /app/AWS-Bedrock-Finance-QnA /app/docuQuery
  pip3 install -r /app/docuQuery/backend/requirements.txt
  cd /app/docuQuery/backend
  uvicorn main:app --host 0.0.0.0 --port 8000 &> uvicorn.log &
  EOL

  tags = {
    Name = "docuQuery-api-server-1"
  }
}

resource "aws_instance" "api_server_2" {
  ami                         = "ami-0de20b1c8590e09c5"
  instance_type               = "t3a.micro"
  subnet_id                   = aws_subnet.docuQuery_subnet_private4.id
  vpc_security_group_ids      = [aws_security_group.api_server_sg.id]
  associate_public_ip_address = false
  key_name                    = aws_key_pair.ec2-key-pair.key_name
  iam_instance_profile        = aws_iam_instance_profile.bedrock_access_profile.name
  user_data                   = <<-EOL
  #!/bin/bash -xe

  yum update -y
  yum install -y git python3-pip
  mkdir /app
  cd /app
  git clone https://github.com/yeseong9769/AWS-Bedrock-Finance-QnA.git
  mv /app/AWS-Bedrock-Finance-QnA /app/docuQuery
  pip3 install -r /app/docuQuery/backend/requirements.txt
  cd /app/docuQuery/backend
  uvicorn main:app --host 0.0.0.0 --port 8000 &> uvicorn.log &
  EOL

  tags = {
    Name = "docuQuery-api-server-2"
  }
}