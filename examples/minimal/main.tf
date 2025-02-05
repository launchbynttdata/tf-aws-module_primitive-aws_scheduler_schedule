// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

data "aws_caller_identity" "current" {}

module "resource_names" {
  source  = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version = "~> 2.0"

  for_each = var.resource_names_map

  region                  = join("", split("-", each.value.region))
  class_env               = var.class_env
  cloud_resource_type     = each.value.name
  instance_env            = var.instance_env
  instance_resource       = var.instance_resource
  maximum_length          = each.value.max_length
  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
}

module "function" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/lambda_function/aws"
  version = "~> 1.0"

  name    = module.resource_names["function"].minimal_random_suffix
  handler = "app.handler"
  runtime = "python3.13"

  create                     = true
  create_package             = true
  source_path                = "./lambda_function"
  create_lambda_function_url = false

  cloudwatch_logs_tags = local.tags
  tags                 = local.tags
}

module "execution_role" {
  source  = "terraform.registry.launch.nttdata.com/module_collection/iam_assumable_role/aws"
  version = "~> 1.1"

  trusted_role_services = ["scheduler.amazonaws.com"]
  trust_policy_conditions = [
    {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [local.account_id]
    }
  ]
  assume_iam_role_policies = [<<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
          {
            "Action": [
                "lambda:InvokeFunction"
            ],
            "Effect": "Allow",
            "Resource": "${module.function.lambda_function_arn}"
          },
          {
            "Action": [
                "sqs:SendMessage"
            ],
            "Effect": "Allow",
            "Resource": "${module.dlq.arn}"
          }
      ]
    }
    EOF
  ]

  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  environment             = var.class_env
  region                  = var.resource_names_map["execution_role"].region
  environment_number      = var.instance_env
  resource_number         = var.instance_resource

  tags = local.tags

}

module "dlq" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/sqs_queue/aws"
  version = "~> 1.0"

  name = module.resource_names["dlq"].minimal_random_suffix

  tags = local.tags
}

module "schedule" {
  source = "../.."

  name                = module.resource_names["schedule"].minimal_random_suffix
  schedule_expression = "rate(1 minute)"

  target_arn      = "arn:aws:scheduler:::aws-sdk:lambda:invoke"
  target_role_arn = module.execution_role.assumable_iam_role
  input = jsonencode({
    "FunctionName" : module.resource_names["function"].minimal_random_suffix,
    "InvocationType" : "Event",
    "Payload" : "{\"message\": \"${var.message}\"}"
  })
  dead_letter_arn = module.dlq.arn
}
