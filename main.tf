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
  bucket_name_dev = "smmp-web-client-dev"
  bucket_name_prod = "smmp-web-client-prod"

  tags_prod = {
    Terraform = "true"
    Stage     = "prod"
    Product   = "client"
  }
  tags_dev = {
    Terraform = "true"
    Stage     = "dev"
    Product   = "client"
  }
}

module "web_client_dev" {
  source      = "./modules/s3-web"
  bucket_name = local.bucket_name_dev
  tags = local.tags_dev
}

module "web_client_prod" {
  source      = "./modules/s3-web"
  bucket_name = local.bucket_name_prod
  tags = local.tags_prod
}

module "cfront_web_client_prod" {
  source = "./modules/cloudfront-dist"
  bucket_regional_domain_name = module.web_client_prod.bucket_regional_domain_name
  bucket_name = local.bucket_name_prod
  tags = local.tags_prod
}

module "cfront_web_client_dev" {
  source = "./modules/cloudfront-dist"
  bucket_regional_domain_name = module.web_client_dev.bucket_regional_domain_name
  bucket_name = local.bucket_name_dev
  tags = local.tags_dev
}