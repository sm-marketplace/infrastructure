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

module "web_client_dev" {
  source      = "./modules/s3-web"
  bucket_name = "smmp-web-client-dev"
  tags = {
    Terraform = "true"
    Stage     = "dev"
    Product   = "client"
  }
}

module "web_client_prod" {
  source      = "./modules/s3-web"
  bucket_name = "smmp-web-client-prod"
  tags = {
    Terraform = "true"
    Stage     = "prod"
    Product   = "client"
  }
}
