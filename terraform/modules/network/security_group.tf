#################### Bastion Host SG ####################
# Bastion 서버에 대한 SSH 접속만 허용
resource "aws_security_group" "bastion_host_sg" {
  name   = "bastion-host-sg"
  vpc_id = aws_vpc.docuQuery_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["218.155.58.38/32"] # 특정 IP에서만 SSH 허용
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # 모든 트래픽 허용 (OutBound)
  }
}

#################### Web Server Load Balancer SG ####################
# Web 서버 Load Balancer에 대한 트래픽 허용
resource "aws_security_group" "web_server_lb_sg" {
  name   = "web-server-lb-sg"
  vpc_id = aws_vpc.docuQuery_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # HTTP 접근 (모든 IP 허용)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # 모든 트래픽 허용 (OutBound)
  }
}

#################### API Server Load Balancer SG ####################
# API 서버 Load Balancer에 대한 트래픽 허용
resource "aws_security_group" "api_server_lb_sg" {
  name   = "api-server-lb-sg"
  vpc_id = aws_vpc.docuQuery_vpc.id

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # API 접근 (모든 IP 허용)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # 모든 트래픽 허용 (OutBound)
  }
}

#################### Web Server SG ####################
# Web 서버 내부 트래픽 및 SSH 트래픽 허용
resource "aws_security_group" "web_server_sg" {
  name   = "web-server-sg"
  vpc_id = aws_vpc.docuQuery_vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_host_sg.id] # Bastion에서 SSH 접근 허용
  }

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.web_server_lb_sg.id] # Web LB에서 HTTP 트래픽 허용
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # 모든 트래픽 허용 (OutBound)
  }
}

#################### API Server SG ####################
# API 서버 내부 트래픽 및 SSH 트래픽 허용
resource "aws_security_group" "api_server_sg" {
  name   = "api-server-sg"
  vpc_id = aws_vpc.docuQuery_vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_host_sg.id] # Bastion에서 SSH 접근 허용
  }

  ingress {
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [aws_security_group.api_server_lb_sg.id] # API LB에서 트래픽 허용
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # 모든 트래픽 허용 (OutBound)
  }
}