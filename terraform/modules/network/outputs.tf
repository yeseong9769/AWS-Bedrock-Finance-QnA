output "vpc_id" {
  value = aws_vpc.docuQuery_vpc.id
}

output "public_subnet_ids" {
  value = [
    aws_subnet.docuQuery_subnet_public1.id,
    aws_subnet.docuQuery_subnet_public2.id
  ]
}

output "private_subnet_ids" {
  value = [
    aws_subnet.docuQuery_subnet_private1.id,
    aws_subnet.docuQuery_subnet_private2.id,
    aws_subnet.docuQuery_subnet_private3.id,
    aws_subnet.docuQuery_subnet_private4.id
  ]
}

output "bastion_host_sg_id" {
  description = "Security Group ID for Bastion Host"
  value       = aws_security_group.bastion_host_sg.id
}

output "web_server_lb_sg_id" {
  description = "Security Group ID for Web Server Load Balancer"
  value       = aws_security_group.web_server_lb_sg.id
}

output "api_server_lb_sg_id" {
  description = "Security Group ID for API Server Load Balancer"
  value       = aws_security_group.api_server_lb_sg.id
}

output "web_server_sg_id" {
  description = "Security Group ID for Web Server"
  value       = aws_security_group.web_server_sg.id
}

output "api_server_sg_id" {
  description = "Security Group ID for API Server"
  value       = aws_security_group.api_server_sg.id
}