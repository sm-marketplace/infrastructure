output "web_client_dev_name" {
  description = "Bucket Name (DEV)"
  value       = module.web_client_dev.name
}

output "web_client_dev_domain" {
  description = "Web Client Domain (DEV)"
  value       = module.cfront_web_client_dev.domain
}

output "web_client_prod_name" {
  description = "Bucket Name (PROD)"
  value       = module.web_client_prod.name
}

output "web_client_prod_domain" {
  description = "FE CL Domain (PROD)"
  value       = module.cfront_web_client_prod.domain
}

output "api_proxy_dev_ec2_public_ip" {
  value = module.api_proxy_dev.ec2_public_dns
}

output "api_proxy_prod_ec2_public_ip" {
  value = module.api_proxy_prod.ec2_public_dns
}