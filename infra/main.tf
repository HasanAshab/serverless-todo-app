module "dynamodb_table" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "5.1.0"

  name         = "${local.project_name}-${var.environment}-dynamodb"
  hash_key     = "id"
  billing_mode = var.db_billing_mode

  attributes = [
    {
      name = "id"
      type = "S"
    }
  ]
}

module "backend" {
  source = "./modules/backend"

  name_prefix       = local.project_name
  environment       = var.environment
  requirements_path = "${local.backend_root}/package.json"
  handlers_dir      = "${local.backend_root}/functions"
  handler_extension = "mjs"

  routes = {
    "GET /todos"         = "list"
    "POST /todos"        = "create"
    "GET /todos/{id}"    = "get"
    "PUT /todos/{id}"    = "update"
    "DELETE /todos/{id}" = "delete"
  }

  dynamodb_table_id  = module.dynamodb_table.dynamodb_table_id
  dynamodb_table_arn = module.dynamodb_table.dynamodb_table_arn

  enable_deletion_protection = var.enable_deletion_protection
}


module "frontend" {
  source = "./modules/frontend"

  name_prefix                = local.project_name
  environment                = var.environment
  cdn_price_class            = var.frontend_cdn_price_class
  enable_deletion_protection = var.enable_deletion_protection
}




