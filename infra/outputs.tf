output "frontend_url" {
  value = "https://${module.frontend.cdn_domain_name}"
}

output "backend_url" {
  value = module.backend.api_gateway_url
}