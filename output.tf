output "stages" {
  value = "${local.instances.*.tags.Stage}"
}

output "web_clients" {
  value = "${module.web_client.*.name}"
}

output "cloudfront_domains" {
  value = "${module.cfront_web_client.*.domain}"
}

output "api_proxies" {
  value = "${module.api_proxy.*.ec2_public_dns}"
}
