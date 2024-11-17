########## IGW ##########
resource "aws_internet_gateway" "docuQuery_igw" {
  vpc_id = aws_vpc.docuQuery_vpc.id

  tags = {
    Name = "docuQuery-igw"
  }
}

########## EIP ##########
resource "aws_eip" "docuQuery_eip_ap_northeast_2a" {
  domain = "vpc"
  tags = {
    Name = "docuQuery-eip-ap-northeast-2a"
  }
}

########## NAT Gateway ##########
resource "aws_nat_gateway" "docuQuery_nat_gateway" {
  allocation_id = aws_eip.docuQuery_eip_ap_northeast_2a.id
  subnet_id     = aws_subnet.docuQuery_subnet_public1.id

  tags = {
    Name = "docuQuery-nat-public1-ap-northeast-2a"
  }
}