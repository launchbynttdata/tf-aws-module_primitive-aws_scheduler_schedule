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

variable "name" {
  description = "The name of the schedule. Changing this value will force creation of a new resource."
  type        = string
  nullable    = false
}

variable "description" {
  description = "The description of the schedule."
  type        = string
  nullable    = true
  default     = null
}

variable "group_name" {
  description = <<EOF
    Name of the schedule group to associate with this schedule. If not
    specified, the `default` schedule group is used.
  EOF
  type        = string
  nullable    = false
  default     = "default"
}

variable "state" {
  description = "Specifies whether the schedule is `ENABLED` or `DISABLED`."
  type        = string
  nullable    = false
  default     = "ENABLED"

  validation {
    condition     = var.state == "ENABLED" || var.state == "DISABLED"
    error_message = "state must be either `ENABLED` or `DISABLED`"
  }
}

variable "start_date" {
  description = <<EOF
    The date, in UTC, after which the schedule can begin invoking its target.
    Depending on the schedule's recurrence expression, invocations might occur
    on, or after, the start date you specify. EventBridge Scheduler ignores the
    start date for one-time schedules. Omitting this value will allow for
    immediate execution. Example: `2030-01-01T01:00:00Z`
  EOF
  type        = string
  nullable    = true
  default     = null

  validation {
    condition     = var.start_date == null ? true : can(regex("^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$", var.start_date))
    error_message = "start_date must be in the format `YYY-MM-DDTHH:MM:SSZ`"
  }
}

variable "end_date" {
  description = <<EOF
    The date, in UTC, before which the schedule can invoke its target.
    Depending on the schedule's recurrence expression, invocations might stop
    on, or before, the end date you specify. EventBridge Scheduler ignores the
    end date for one-time schedules. Omitting this value will allow the
    schedule to run indefinitely. Example: `2030-01-01T01:00:00Z`.
  EOF
  type        = string
  nullable    = true
  default     = null

  validation {
    condition     = var.end_date == null ? true : can(regex("^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$", var.end_date))
    error_message = "end_date must be in the format `YYYY-MM-DDTHH:MM:SSZ`"
  }
}

variable "schedule_expression" {
  description = <<EOF
    Defines when the schedule runs. For more information on schedule types,
    as well as details on timezones and DST handling, see Schedule Types:
    https://docs.aws.amazon.com/scheduler/latest/UserGuide/schedule-types.html
    Examples: `cron(0 20 * * ? *)`, `rate(5 minutes)`, `at(2025-01-01T00:00:00)`.
  EOF
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^(cron|rate|at)\\(.*\\)$", var.schedule_expression))
    error_message = "schedule_expression must be in the format `cron()`, `rate()`, or `at()`"
  }
}

variable "schedule_expression_timezone" {
  description = <<EOF
    The timezone for the schedule. If not specified, the default timezone is `UTC`.
    For more information on timezones and DST handling, see Schedule Types:
    https://docs.aws.amazon.com/scheduler/latest/UserGuide/schedule-types.html
  EOF
  type        = string
  nullable    = false
  default     = "UTC"
}

variable "input" {
  description = <<EOF
    Optional text or well-formed JSON, passed to the target. The parameters
    and shape of the JSON you set are determined by the service API your
    schedule invokes. To find this information, see the API reference for the
    service you want to target.
  EOF
  type        = string
  nullable    = true
  default     = null
}

variable "flexible_time_window_minutes" {
  description = <<EOF
    The maximum amount of time, in minutes, that the schedule can delay the
    invocation of its target. The value must be between 1 and 1440 minutes.
    If not specified, the schedule will run immediately at its scheduled time.
  EOF
  type        = number
  nullable    = true
  default     = null

  validation {
    condition     = var.flexible_time_window_minutes == null ? true : (var.flexible_time_window_minutes >= 1 && var.flexible_time_window_minutes <= 1440)
    error_message = "flexible_time_window_minutes must be between 1 and 1440 minutes"
  }
}

variable "target_arn" {
  description = <<EOF
    The ARN of the target to invoke. This uses the Universal Target ARN format,
    not the standard ARN of the resource itself. For more details on constructing
    a universal target ARN, see:
    https://docs.aws.amazon.com/scheduler/latest/UserGuide/managing-targets-universal.html#supported-universal-targets.

    Example: `arn:aws:scheduler:::aws-sdk:<service>:<apiAction>`
  EOF
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^arn:aws:scheduler:::aws-sdk:[a-zA-Z0-9-]+:[a-zA-Z0-9-]+$", var.target_arn))
    error_message = "target_arn must be in the format `arn:aws:scheduler:::aws-sdk:<service>:<apiAction>`"
  }
}

variable "target_role_arn" {
  description = <<EOF
    The ARN of the IAM role to assume when invoking the target. This role must
    have the necessary permissions to invoke the target. For more information on
    creating a role for EventBridge Scheduler, see:
    https://docs.aws.amazon.com/scheduler/latest/UserGuide/setting-up.html#setting-up-execution-role.

    When creating an IAM role to handle execution of services from a schedule,
    you should scope the policy to avoid the confused deputy problem:
    https://docs.aws.amazon.com/scheduler/latest/UserGuide/cross-service-confused-deputy-prevention.html

    Example: `arn:aws:iam::123456789012:role/service-role/MySchedulerRole`
  EOF
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/[a-zA-Z0-9_/-]+$", var.target_role_arn))
    error_message = "target_role_arn must be in the format `arn:aws:iam::123456789012:role/service-role/MySchedulerRole`"
  }
}

variable "dead_letter_arn" {
  description = "ARN of the SQS queue specified as the destination for the dead-letter queue."
  type        = string
  nullable    = true
  default     = null

  validation {
    condition     = var.dead_letter_arn == null ? true : can(regex("^arn:aws:sqs:.+$", var.dead_letter_arn))
    error_message = "dead_letter_arn is expected to be an SQS ARN."
  }
}

variable "maximum_event_age_in_seconds" {
  description = <<EOF
    The maximum age of a message in seconds that the schedule can retry.
    If the message is older than this value, the schedule will not retry the
    message. The value ranges between 60 and 86400 seconds (default)
  EOF
  type        = number
  nullable    = true
  default     = null

  validation {
    condition     = var.maximum_event_age_in_seconds == null ? true : (var.maximum_event_age_in_seconds >= 60 && var.maximum_event_age_in_seconds <= 86400)
    error_message = "maximum_event_age_in_seconds must be between 60 and 86400 seconds"
  }
}

variable "maximum_retry_attempts" {
  description = <<EOF
    The number of times the schedule will retry the invocation in case of
    failure. The value ranges between 0 and 185 (default).
  EOF
  type        = number
  nullable    = true
  default     = null

  validation {
    condition     = var.maximum_retry_attempts == null ? true : (var.maximum_retry_attempts >= 0 && var.maximum_retry_attempts <= 185)
    error_message = "maximum_retry_attempts must be between 0 and 185"
  }
}
