output "instance_public_key" {
  description = "Public key of docuQuery-key-pair"
  value       = tls_private_key.docuQuery-key.public_key_openssh
  sensitive   = true
}

output "instance_private_key" {
  description = "Private key of docuQuery-key-pair"
  value       =  tls_private_key.docuQuery-key.private_key_pem
  sensitive   = true
}