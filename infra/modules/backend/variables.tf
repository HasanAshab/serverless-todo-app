variable "environment" {
  description = "Environment name"
  type        = string
}

variable "name_prefix" {
  description = "A prefix used for naming resources"
  type        = string
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
}

variable "runtime" {
  description = "Runtime for Lambda functions"
  type        = string
  default = "nodejs22.x"
}
variable "functions_path" {
  description = "Functions path"
  type        = string
}

variable "npm_requirements_path" {
  description = "NPM requirements path"
  type        = string
}

variable "handler_function_name" {
  description = "Handler function name"
  type        = string
  default     = "handler"
}

variable "handler_extension" {
  description = "Handler extension"
  type        = string
  default     = "mjs"
}

variable "dynamodb_table_id" {
  description = "DynamoDB table ID"
  type        = string
}

variable "dynamodb_table_arn" {
  description = "DynamoDB table ARN"
  type        = string  
}