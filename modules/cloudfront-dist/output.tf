output "domain" {
  description = "Cloudfront domain"
  value       = aws_cloudfront_distribution.www_distribution.domain_name
}

output "id" {
  description = "Cloudfront Distribution ID"
  value       = aws_cloudfront_distribution.www_distribution.id
}