#################### Public Load Balancer ####################
resource "aws_lb" "public_lb" {
  name               = "docuQuery-public-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups   = [aws_security_group.web_server_sg.id]
  subnets            = [
    aws_subnet.docuQuery_subnet_public1.id,
    aws_subnet.docuQuery_subnet_public2.id
  ]

  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "docuQuery-public-lb"
  }
}

#################### Internal Load Balancer ####################
resource "aws_lb" "internal_lb" {
  name               = "docuQuery-internal-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups   = [aws_security_group.api_server_sg.id]
  subnets            = [
    aws_subnet.docuQuery_subnet_private1.id,
    aws_subnet.docuQuery_subnet_private2.id
  ]

  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "docuQuery-internal-lb"
  }
}