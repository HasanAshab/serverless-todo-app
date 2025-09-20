# output "urls" {
#   value = { for k, v in module.lambda_functions : k => v.lambda_function_url }
# }

output "urls" {
  value = module.api_gateway.api_endpoint
}