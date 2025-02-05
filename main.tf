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

resource "aws_scheduler_schedule" "schedule" {
  name        = var.name
  description = var.description
  group_name  = var.group_name
  state       = var.state

  start_date = var.start_date
  end_date   = var.end_date

  schedule_expression          = var.schedule_expression
  schedule_expression_timezone = var.schedule_expression_timezone

  target {
    arn      = var.target_arn
    role_arn = var.target_role_arn
    input    = var.input

    dynamic "dead_letter_config" {
      for_each = var.dead_letter_arn == null ? {} : { "config" = var.dead_letter_arn }
      content {
        arn = dead_letter_config.value
      }
    }

    retry_policy {
      maximum_event_age_in_seconds = var.maximum_event_age_in_seconds
      maximum_retry_attempts       = var.maximum_retry_attempts
    }
  }

  dynamic "flexible_time_window" {
    for_each = var.flexible_time_window_minutes == null ? {} : { "window" = var.flexible_time_window_minutes }
    content {
      mode                      = "FLEXIBLE"
      maximum_window_in_minutes = flexible_time_window.value.window
    }
  }

  dynamic "flexible_time_window" {
    for_each = var.flexible_time_window_minutes == null ? { "off" = "off" } : {}
    content {
      mode = "OFF"
    }
  }
}
