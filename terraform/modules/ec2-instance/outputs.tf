output "web_server_1_id" {
    description = "The ID of the first web server"
    value       = aws_instance.web_server_1.id
}

output "web_server_2_id" {
    description = "The ID of the second web server"
    value       = aws_instance.web_server_2.id
}

output "api_server_1_id" {
    description = "The ID of the first API server"
    value       = aws_instance.api_server_1.id
}

output "api_server_2_id" {
    description = "The ID of the second API server"
    value       = aws_instance.api_server_2.id
}