terraform {
  backend "s3" {
    bucket         = "rgb-terraformbe"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "rgb-terraform-table"
  }
}

provider "aws" {
  region = "us-east-1"
}

locals {
  instances = [
    {
      bucket_name = "smmp-web-client-dev"
      tags = {
        Terraform = "true"
        Stage     = "dev"
        Product   = "client"
      }
    },
    {
      bucket_name = "smmp-web-client-prod"
      tags = {
        Terraform = "true"
        Stage     = "prod"
        Product   = "client"
      }
    }
  ]
}

module "web_client" {
  count       = length(local.instances)
  source      = "./modules/s3-web"
  bucket_name = local.instances[count.index].bucket_name
  tags        = local.instances[count.index].tags
}

module "cfront_web_client" {
  count                       = length(local.instances)
  source                      = "./modules/cloudfront-dist"
  bucket_regional_domain_name = module.web_client[count.index].bucket_regional_domain_name
  bucket_name                 = local.instances[count.index].bucket_name
  tags                        = local.instances[count.index].tags
}

module "api_proxy" {
  count          = length(local.instances)
  source         = "./modules/ec2-api"
  key_name       = "SMMP_${local.instances[count.index].tags.Stage}_ShhKey"
  security_group = "${local.instances[count.index].tags.Stage}_security_group"
  tags           = local.instances[count.index].tags
}

module "monitor" {
  count          = length(local.instances)
  source         = "./modules/ec2-api"
  key_name       = "SMMP_monitor_${local.instances[count.index].tags.Stage}_ShhKey"
  security_group = "${local.instances[count.index].tags.Stage}_monitor_security_group"
  tags           = local.instances[count.index].tags
}

# # =========================== TEST

# resource "aws_api_gateway_rest_api" "api" {
#  name = "api-gateway"
#  description = "Proxy to handle requests to our API"
# }

# resource "aws_api_gateway_resource" "resource" {
#   rest_api_id = "${aws_api_gateway_rest_api.api.id}"
#   parent_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
#   path_part   = "{proxy+}"
# }
# resource "aws_api_gateway_method" "method" {
#   rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
#   resource_id   = "${aws_api_gateway_resource.resource.id}"
#   http_method   = "ANY"
#   authorization = "NONE"
#   request_parameters = {
#     "method.request.path.proxy" = true
#   }
# }
# resource "aws_api_gateway_integration" "integration" {
#   rest_api_id = "${aws_api_gateway_rest_api.api.id}"
#   resource_id = "${aws_api_gateway_resource.resource.id}"
#   http_method = "${aws_api_gateway_method.method.http_method}"
#   integration_http_method = "ANY"
#   type                    = "HTTP_PROXY"
#   uri                     = "http://ec2-35-169-79-235.compute-1.amazonaws.com/{proxy}"
 
#   request_parameters =  {
#     "integration.request.path.proxy" = "method.request.path.proxy"
#   }
# }

# https://ljatgbklcf.execute-api.us-east-1.amazonaws.com/{stage_name}/
