variable "bucket_regional_domain_name" {
  description = ""
  type        = string
}

variable "bucket_name" {
  description = ""
  type        = string
}

variable "tags" {
  description = "Tags to set on the cloudfront distribution."
  type        = map(string)
  default     = {}
}