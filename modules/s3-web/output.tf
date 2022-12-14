output "arn" {
  description = "ARN of the bucket"
  value       = aws_s3_bucket.web_bucket.arn
}

output "name" {
  description = "Name (id) of the bucket"
  value       = aws_s3_bucket.web_bucket.id
}

output "bucket_regional_domain_name" {
  description = "Domain name of the bucket"
  value       = aws_s3_bucket.web_bucket.bucket_regional_domain_name
}

output "domain" {
  description = "Domain name of the bucket"
  value       = aws_s3_bucket_website_configuration.web_bucket.website_domain
}