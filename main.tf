terraform {
  backend "s3" {
    bucket         = "rogrp-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "rogrp-table"
  }
}

provider "aws" {
    region  = "us-east-1"
}

// politica para que el publico pueda acceder al bucket
data "aws_iam_policy_document" "website_policy" {
  statement {
    actions = [
      "s3:GetObject"
    ]
    principals {
      identifiers = ["*"]
      type = "AWS"
    }
    resources = [
      "arn:aws:s3:::${var.domain_name}/*"
    ]

  }
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = var.domain_name
}

resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = data.aws_iam_policy_document.website_policy.json
}

resource "aws_s3_bucket_website_configuration" "website_bucket_conf" {
  bucket = aws_s3_bucket.website_bucket.bucket
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}