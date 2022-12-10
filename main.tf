terraform {
  backend "s3" {
    bucket         = "rogrp-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "rogrp-table"
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
  bucket_name = local.instances[count.index].name
  tags        = local.instances[count.index].tags
}

module "cfront_web_client" {
  count                       = length(local.instances)
  source                      = "./modules/cloudfront-dist"
  bucket_regional_domain_name = module.web_client_dev.bucket_regional_domain_name
  bucket_name                 = local.instances[count.index].bucket_name
  tags                        = local.instances[count.index].tags
}

module "api_proxy" {
  count          = length(local.instances)
  source         = "./modules/ec2-api"
  key_name       = "SMMP_${local.instances[count.index].tags[Stage]}_ShhKey"
  security_group = "${local.instances[count.index].tags[Stage]}_security_group"
  tags           = local.instances[count.index].tags
}
