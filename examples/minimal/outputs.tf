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

output "id" {
  value = module.schedule.id
}

output "arn" {
  value = module.schedule.arn
}

output "log_group_arn" {
  value = module.function.lambda_cloudwatch_log_group_arn
}

output "log_group_name" {
  value = module.function.lambda_cloudwatch_log_group_name
}

output "function_name" {
  value = module.function.lambda_function_name
}

output "expected_message" {
  value = var.message
}
