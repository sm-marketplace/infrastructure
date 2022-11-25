output "ei_public_dns" {
  value       = aws_instance.api_instance.public_dns
}

output "ec2_public_dns" {
  value       = aws_instance.api_instance.public_dns
}