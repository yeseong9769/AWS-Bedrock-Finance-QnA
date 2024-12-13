#################### Public Load Balancer ####################
resource "aws_lb_target_group" "web_server_tg" {
  name     = "docuQuery-web-server-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/healthz"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "docuQuery-web-server-tg"
  }
}

resource "aws_lb_target_group_attachment" "web_server_1_attachment" {
  target_group_arn = aws_lb_target_group.web_server_tg.arn
  target_id        = var.target_id[0]
  port             = 8080
}

resource "aws_lb_target_group_attachment" "web_server_2_attachment" {
  target_group_arn = aws_lb_target_group.web_server_tg.arn
  target_id        = var.target_id[1]
  port             = 8080
}


resource "aws_lb_listener" "public_lb_listener" {
  load_balancer_arn = aws_lb.public_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_server_tg.arn
  }
}


resource "aws_lb" "public_lb" {
  name               = "docuQuery-public-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_ids[0]]
  subnets = var.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = "docuQuery-public-lb"
  }
}

#################### Internal Load Balancer ####################
resource "aws_lb_target_group" "api_server_tg" {
  name     = "docuQuery-api-server-tg"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "docuQuery-api-server-tg"
  }
}

resource "aws_lb_target_group_attachment" "api_server_1_attachment" {
  target_group_arn = aws_lb_target_group.api_server_tg.arn
  target_id        = var.target_id[2]
  port             = 8000
}

resource "aws_lb_target_group_attachment" "api_server_2_attachment" {
  target_group_arn = aws_lb_target_group.api_server_tg.arn
  target_id        = var.target_id[3]
  port             = 8000
}

resource "aws_lb_listener" "internal_lb_listener" {
  load_balancer_arn = aws_lb.internal_lb.arn
  port              = 8000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_server_tg.arn
  }
}

resource "aws_lb" "internal_lb" {
  name               = "docuQuery-internal-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.security_group_ids[1]]
  subnets = [
    var.private_subnet_ids[0],
    var.private_subnet_ids[1]
  ]

  enable_deletion_protection = false

  tags = {
    Name = "docuQuery-internal-lb"
  }
}