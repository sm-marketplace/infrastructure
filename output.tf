output "stages" {
  value = local.instances.*.tags.Stage
}

output "buckets" {
  value = module.web_client.*.name
}

output "cloudfront_domains" {
  value = module.cfront_web_client.*.domain
}

output "cloudfront_ids" {
  value = module.cfront_web_client.*.id
}

output "api_domains" {
  value = module.api_proxy.*.ec2_public_dns
}
