output "instance_id" {
  description = "The ID of the EC2 instance."
  value       = aws_instance.web_app_instance.id
}

output "public_ipv4" {
  description = "The public IPv4 address of the EC2 instance."
  value       = aws_instance.web_app_instance.public_ip
}

output "public_dns" {
  description = "The public DNS name of the EC2 instance."
  value       = aws_instance.web_app_instance.public_dns
}
