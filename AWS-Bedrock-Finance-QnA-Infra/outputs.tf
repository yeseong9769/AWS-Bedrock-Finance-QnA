output "internal_lb_dns_name" {
  value = aws_lb.internal_lb.dns_name
}

output "public_lb_dns_name" {
  value = aws_lb.public_lb.dns_name
}