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
  ami                         = "ami-0de20b1c8590e09c5"
  instance_type               = "t3a.micro"
  subnet_id                   = aws_subnet.docuQuery_subnet_private1.id
  vpc_security_group_ids      = [aws_security_group.web_server_sg.id]
  associate_public_ip_address = false
  key_name                    = aws_key_pair.ec2-key-pair.key_name

  tags = {
    Name = "docuQuery-web-server-1"
  }
}

resource "aws_instance" "web_server_2" {
  ami                         = "ami-0de20b1c8590e09c5"
  instance_type               = "t3a.micro"
  subnet_id                   = aws_subnet.docuQuery_subnet_private2.id
  vpc_security_group_ids      = [aws_security_group.web_server_sg.id]
  associate_public_ip_address = false
  key_name                    = aws_key_pair.ec2-key-pair.key_name

  tags = {
    Name = "docuQuery-web-server-2"
  }
}

#################### API Server ####################
resource "aws_instance" "api_server_1" {
  ami                         = "ami-0de20b1c8590e09c5"
  instance_type               = "t3a.micro"
  subnet_id                   = aws_subnet.docuQuery_subnet_private3.id
  vpc_security_group_ids      = [aws_security_group.api_server_sg.id]
  associate_public_ip_address = false
  key_name                    = aws_key_pair.ec2-key-pair.key_name

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

  tags = {
    Name = "docuQuery-api-server-2"
  }
}