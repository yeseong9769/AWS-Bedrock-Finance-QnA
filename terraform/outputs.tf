output "public_lb_dns_name" {
  description = "The DNS name of the public load balancer"
  value       = module.load_balancer.public_lb_dns_name
}