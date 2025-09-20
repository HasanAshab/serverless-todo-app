module "dynamodb_table" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "5.1.0"

  name         = "${local.project_name}-dynamodb-${var.environment}"
  hash_key     = "id"
  billing_mode = "PAY_PER_REQUEST"

  # The module requires a list of attributes, even for a single hash key.
  attributes = [
    {
      name = "id"
      type = "S"
    }
  ]
}

module "backend" {
  source = "./modules/backend"

  name_prefix    = local.project_name
  environment    = var.environment

  functions_path = "${local.backend_root}/functions"
  npm_requirements_path = "${local.backend_root}/package.json"

  dynamodb_table_id = module.dynamodb_table.dynamodb_table_id
  dynamodb_table_arn = module.dynamodb_table.dynamodb_table_arn

  enable_deletion_protection = var.enable_deletion_protection
}

# module "frontend" {
#   source = "./modules/frontend"

#   name_prefix     = local.project_name
#   domain_names    = var.frontend_domains
#   cdn_price_class = var.frontend_cdn_price_class
#   enable_deletion_protection = var.enable_deletion_protection
# }




