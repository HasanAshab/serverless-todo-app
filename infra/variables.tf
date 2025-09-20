variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "enable_deletion_protection" {
  description = "Deletion protection"
  type        = bool
  default     = false
}

variable "db_billing_mode" {
  description = "DynamoDB billing mode"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "frontend_cdn_price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_100"
}
