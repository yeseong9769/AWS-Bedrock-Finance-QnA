########## Public Route Table ##########
resource "aws_route_table" "docuQuery_rtb_public" {
  vpc_id = aws_vpc.docuQuery_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.docuQuery_igw.id
  }

  tags = {
    Name = "docuQuery-rtb-public"
  }
}

resource "aws_route_table_association" "docuQuery_rtb_public_association_1" {
  subnet_id      = aws_subnet.docuQuery_subnet_public1.id
  route_table_id = aws_route_table.docuQuery_rtb_public.id
}

resource "aws_route_table_association" "docuQuery_rtb_public_association_2" {
  subnet_id      = aws_subnet.docuQuery_subnet_public2.id
  route_table_id = aws_route_table.docuQuery_rtb_public.id
}

########## Private ##########
#################### Private 1 ####################
resource "aws_route_table" "docuQuery_rtb_private1" {
  vpc_id = aws_vpc.docuQuery_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.docuQuery_nat_gateway.id
  }

  tags = {
    Name = "docuQuery-rtb-private1-ap-northeast-2a"
  }
}

resource "aws_route_table_association" "docuQuery_rtb_private1_association" {
  subnet_id      = aws_subnet.docuQuery_subnet_private1.id
  route_table_id = aws_route_table.docuQuery_rtb_private1.id
}

#################### Private 2 ####################
resource "aws_route_table" "docuQuery_rtb_private2" {
  vpc_id = aws_vpc.docuQuery_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.docuQuery_nat_gateway.id
  }

  tags = {
    Name = "docuQuery-rtb-private2-ap-northeast-2c"
  }
}

resource "aws_route_table_association" "docuQuery_rtb_private2_association" {
  subnet_id      = aws_subnet.docuQuery_subnet_private2.id
  route_table_id = aws_route_table.docuQuery_rtb_private2.id
}

#################### Private 3 ####################
resource "aws_route_table" "docuQuery_rtb_private3" {
  vpc_id = aws_vpc.docuQuery_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.docuQuery_nat_gateway.id
  }

  tags = {
    Name = "docuQuery-rtb-private2-ap-northeast-2a"
  }
}

resource "aws_route_table_association" "docuQuery_rtb_private3_association" {
  subnet_id      = aws_subnet.docuQuery_subnet_private3.id
  route_table_id = aws_route_table.docuQuery_rtb_private3.id
}


#################### Private 4 ####################
resource "aws_route_table" "docuQuery_rtb_private4" {
  vpc_id = aws_vpc.docuQuery_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.docuQuery_nat_gateway.id
  }

  tags = {
    Name = "docuQuery-rtb-private2-ap-northeast-2c"
  }
}

resource "aws_route_table_association" "docuQuery_rtb_private4_association" {
  subnet_id      = aws_subnet.docuQuery_subnet_private4.id
  route_table_id = aws_route_table.docuQuery_rtb_private4.id
}