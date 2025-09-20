locals {
  function_files = fileset(var.functions_path, "*.${var.handler_extension}")
}

module "lambda_functions" {
  source = "terraform-aws-modules/lambda/aws"
  version = "8.1.0"

  # Use for_each to create a separate instance of the module for each file.
  for_each = local.function_files

  # The function name is derived from the filename (e.g., "create", "delete").
  function_name = "fn-${var.name_prefix}-${trimsuffix(each.value, ".${var.handler_extension}")}-${var.environment}"

  # The source path is full path to the .mjs file.
  source_path = [
    # Include the function file
    "${var.functions_path}/${each.value}",

    # Install dependencies from package.json
    { npm_requirements = var.npm_requirements_path }
  ]

  # The handler is `<filename>.<handler_function_name>`.
  # For example: `create.handler`.
  handler = "${trimsuffix(each.value, ".${var.handler_extension}")}.${var.handler_function_name}"

  runtime = var.runtime
  publish = true

  # Add IAM policy attachment
  attach_policy_json = true
  policy_json        = templatefile("${path.module}/templates/lambda_policy.json", {
    dynamodb_arn = var.dynamodb_table_arn
  })

  allowed_triggers = {
    apigw = {
      service    = "apigateway"
      source_arn = "${module.api_gateway.api_execution_arn}/*/*"
    }
  }

  environment_variables = {
    DYNAMODB_TABLE = var.dynamodb_table_id
  }
}


module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"
  version = "5.3.1"
  name          = "dev-http"
  description   = "My awesome HTTP API Gateway"
  protocol_type = "HTTP"

  cors_configuration = {
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }

  # Custom domain
  # domain_name = var.domain_name
  create_domain_name = false

  routes = {
    "GET /todos" = {
      integration = {
        uri                    = module.lambda_functions["list.mjs"].lambda_function_invoke_arn
        payload_format_version = "2.0"
        timeout_milliseconds   = 12000
      }
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}