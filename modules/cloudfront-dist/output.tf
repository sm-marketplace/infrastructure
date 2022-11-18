output "domain" {
  description = "Cloudfront domain"
  value       = aws_cloudfront_distribution.www_distribution.domain_name
}