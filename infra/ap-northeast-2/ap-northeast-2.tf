########## VPC ##########
resource "aws_vpc" "doquQuery_vpc" {
  cidr_block           = "172.28.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "doquQuery-vpc"
  }
}

########## Public Subnet ##########
resource "aws_subnet" "doquQuery_subnet_public1" {
  vpc_id            = aws_vpc.doquQuery_vpc.id
  cidr_block        = "172.28.0.0/20"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "doquQuery-subnet-public1-ap-northeast-2a"
  }
}

resource "aws_subnet" "doquQuery_subnet_public2" {
  vpc_id            = aws_vpc.doquQuery_vpc.id
  cidr_block        = "172.28.16.0/20"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "doquQuery-subnet-public2-ap-northeast-2c"
  }
}

########## Private Subnet ##########
resource "aws_subnet" "doquQuery_subnet_private1" {
  vpc_id            = aws_vpc.doquQuery_vpc.id
  cidr_block        = "172.28.128.0/22"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "doquQuery-subnet-private1-ap-northeast-2a"
  }
}

resource "aws_subnet" "doquQuery_subnet_private2" {
  vpc_id            = aws_vpc.doquQuery_vpc.id
  cidr_block        = "172.28.132.0/22"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "doquQuery-subnet-private2-ap-northeast-2c"
  }
}

resource "aws_subnet" "doquQuery_subnet_private3" {
  vpc_id            = aws_vpc.doquQuery_vpc.id
  cidr_block        = "172.28.136.0/22"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "doquQuery-subnet-private3-ap-northeast-2a"
  }
}

resource "aws_subnet" "doquQuery_subnet_private4" {
  vpc_id            = aws_vpc.doquQuery_vpc.id
  cidr_block        = "172.28.140.0/22"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "doquQuery-subnet-private4-ap-northeast-2c"
  }
}

########## IGW ##########
resource "aws_internet_gateway" "doquQuery_igw" {
  vpc_id = aws_vpc.doquQuery_vpc.id

  tags = {
    Name = "doquQuery-igw"
  }
}

########## EIP ##########
resource "aws_eip" "doquQuery_eip_ap_northeast_2a" {
  domain = "vpc"
  tags = {
    Name = "doquQuery-eip-ap-northeast-2a"
  }
}

########## NAT Gateway ##########
resource "aws_nat_gateway" "doquQuery_nat_gateway" {
  allocation_id = aws_eip.doquQuery_eip_ap_northeast_2a.id
  subnet_id     = aws_subnet.doquQuery_subnet_public1.id

  tags = {
    Name = "doquQuery-nat-public1-ap-northeast-2a"
  }
}

########## Security Group ##########
resource "aws_security_group" "bastion_host_sg" {
  name   = "bastion-host-sg"
  vpc_id = aws_vpc.doquQuery_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["218.155.164.111/32"] # 변경 필요: 특정 IP 범위로 제한
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "web_server_sg" {
  name   = "web_server_sg"
  vpc_id = aws_vpc.doquQuery_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 변경 필요: 특정 IP 범위로 제한
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

########## Instance ##########
#################### Bastion Host ####################
resource "aws_instance" "bastion_host" {
  ami           = "ami-0c63ba386d57a6296"
  instance_type = "t3a.nano"
  subnet_id     = aws_subnet.doquQuery_subnet_public2.id
  vpc_security_group_ids = [aws_security_group.bastion_host_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "doquQuery-bastion-host"
  }
}

#################### Web Server ####################
resource "aws_instance" "web_server_1" {
  ami           = "ami-0c63ba386d57a6296"
  instance_type = "t3a.micro"
  subnet_id     = aws_subnet.doquQuery_subnet_private1.id
  vpc_security_group_ids = [aws_security_group.web_server_sg.id]
  associate_public_ip_address = false

  tags = {
    Name = "doquQuery-web-server-1"
  }
}

resource "aws_instance" "web_server_2" {
  ami           = "ami-0c63ba386d57a6296"
  instance_type = "t3a.micro"
  subnet_id     = aws_subnet.doquQuery_subnet_private2.id
  vpc_security_group_ids = [aws_security_group.web_server_sg.id]
  associate_public_ip_address = false

  tags = {
    Name = "doquQuery-web-server-2"
  }
}