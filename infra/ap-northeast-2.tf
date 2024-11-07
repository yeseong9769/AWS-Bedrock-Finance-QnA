provider "aws" {
  region                   = "ap-northeast-2"
  shared_credentials_files = [".aws/credentials"]
}

# Create VPC
resource "aws_vpc" "doquQuery_vpc" {
  cidr_block           = "172.28.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "doquQuery-vpc"
  }
}

# Create subnets
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
  availability_zone = "ap-northeast-2b"

  tags = {
    Name = "doquQuery-subnet-public2-ap-northeast-2b"
  }
}

resource "aws_subnet" "doquQuery_subnet_private1" {
  vpc_id            = aws_vpc.doquQuery_vpc.id
  cidr_block        = "172.28.128.0/20"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "doquQuery-subnet-private1-ap-northeast-2a"
  }
}

resource "aws_subnet" "doquQuery_subnet_private2" {
  vpc_id            = aws_vpc.doquQuery_vpc.id
  cidr_block        = "172.28.144.0/20"
  availability_zone = "ap-northeast-2b"

  tags = {
    Name = "doquQuery-subnet-private2-ap-northeast-2b"
  }
}

# Create internet gateway
resource "aws_internet_gateway" "doquQuery_igw" {
  vpc_id = aws_vpc.doquQuery_vpc.id

  tags = {
    Name = "doquQuery-igw"
  }
}

# Create public route table and associate with public subnets
resource "aws_route_table" "doquQuery_rtb_public" {
  vpc_id = aws_vpc.doquQuery_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.doquQuery_igw.id
  }

  tags = {
    Name = "doquQuery-rtb-public"
  }
}

resource "aws_route_table_association" "doquQuery_rtb_public_association_1" {
  subnet_id      = aws_subnet.doquQuery_subnet_public1.id
  route_table_id = aws_route_table.doquQuery_rtb_public.id
}

resource "aws_route_table_association" "doquQuery_rtb_public_association_2" {
  subnet_id      = aws_subnet.doquQuery_subnet_public2.id
  route_table_id = aws_route_table.doquQuery_rtb_public.id
}

# Create elastic IP and NAT gateway
resource "aws_eip" "doquQuery_eip_ap_northeast_2a" {
  domain = "vpc"
  tags = {
    Name = "doquQuery-eip-ap-northeast-2a"
  }
}

resource "aws_nat_gateway" "doquQuery_nat_gateway" {
  allocation_id = aws_eip.doquQuery_eip_ap_northeast_2a.id
  subnet_id     = aws_subnet.doquQuery_subnet_public1.id

  tags = {
    Name = "doquQuery-nat-public1-ap-northeast-2a"
  }
}

# Create private route tables and associate with private subnets
resource "aws_route_table" "doquQuery_rtb_private1" {
  vpc_id = aws_vpc.doquQuery_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.doquQuery_nat_gateway.id
  }

  tags = {
    Name = "doquQuery-rtb-private1-ap-northeast-2a"
  }
}

resource "aws_route_table_association" "doquQuery_rtb_private1_association" {
  subnet_id      = aws_subnet.doquQuery_subnet_private1.id
  route_table_id = aws_route_table.doquQuery_rtb_private1.id
}

resource "aws_route_table" "doquQuery_rtb_private2" {
  vpc_id = aws_vpc.doquQuery_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.doquQuery_nat_gateway.id
  }

  tags = {
    Name = "doquQuery-rtb-private2-ap-northeast-2b"
  }
}

resource "aws_route_table_association" "doquQuery_rtb_private2_association" {
  subnet_id      = aws_subnet.doquQuery_subnet_private2.id
  route_table_id = aws_route_table.doquQuery_rtb_private2.id
}
