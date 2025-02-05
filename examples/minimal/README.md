# with_cake

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.84.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | terraform.registry.launch.nttdata.com/module_library/resource_name/launch | ~> 2.0 |
| <a name="module_function"></a> [function](#module\_function) | terraform.registry.launch.nttdata.com/module_primitive/lambda_function/aws | ~> 1.0 |
| <a name="module_execution_role"></a> [execution\_role](#module\_execution\_role) | terraform.registry.launch.nttdata.com/module_collection/iam_assumable_role/aws | ~> 1.1 |
| <a name="module_dlq"></a> [dlq](#module\_dlq) | terraform.registry.launch.nttdata.com/module_primitive/sqs_queue/aws | ~> 1.0 |
| <a name="module_schedule"></a> [schedule](#module\_schedule) | ../.. | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | A map of key to resource\_name that will be used by tf-launch-module\_library-resource\_name to generate resource names | <pre>map(object({<br/>    name       = string<br/>    max_length = optional(number, 60)<br/>    region     = optional(string, "us-east-2")<br/>  }))</pre> | <pre>{<br/>  "dlq": {<br/>    "max_length": 60,<br/>    "name": "dlq",<br/>    "region": "us-east-2"<br/>  },<br/>  "execution_role": {<br/>    "max_length": 60,<br/>    "name": "excrle",<br/>    "region": "us-east-2"<br/>  },<br/>  "function": {<br/>    "max_length": 60,<br/>    "name": "fn",<br/>    "region": "us-east-2"<br/>  },<br/>  "schedule": {<br/>    "max_length": 80,<br/>    "name": "schd",<br/>    "region": "us-east-2"<br/>  }<br/>}</pre> | no |
| <a name="input_instance_env"></a> [instance\_env](#input\_instance\_env) | Number that represents the instance of the environment. | `number` | `0` | no |
| <a name="input_instance_resource"></a> [instance\_resource](#input\_instance\_resource) | Number that represents the instance of the resource. | `number` | `0` | no |
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | (Required) Name of the product family for which the resource is created.<br/>    Example: org\_name, department\_name. | `string` | `"launch"` | no |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | (Required) Name of the product service for which the resource is created.<br/>    For example, backend, frontend, middleware etc. | `string` | `"eventbridge_schedule"` | no |
| <a name="input_class_env"></a> [class\_env](#input\_class\_env) | (Required) Environment where resource is going to be deployed. For example. dev, qa, uat | `string` | `"demo"` | no |
| <a name="input_message"></a> [message](#input\_message) | A message to populate in the EventBridge message to Lambda. | `string` | `"Hello from EventBridge!"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_arn"></a> [arn](#output\_arn) | n/a |
| <a name="output_log_group_arn"></a> [log\_group\_arn](#output\_log\_group\_arn) | n/a |
| <a name="output_log_group_name"></a> [log\_group\_name](#output\_log\_group\_name) | n/a |
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | n/a |
| <a name="output_expected_message"></a> [expected\_message](#output\_expected\_message) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
