# output "frontend_url" {
#   value = "https://${module.frontend.cdn_domain_name}"
# }

output "lambda_urls" {
  value = module.backend.urls
}
