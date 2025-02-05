# tf-aws-module_primitive-aws_scheduler_schedule

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: CC BY-NC-ND 4.0](https://img.shields.io/badge/License-CC_BY--NC--ND_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-nd/4.0/)

## Overview

Provides an EventBridge Scheduler resource that can trigger actions on a schedule. This resource utilizes [universal targets](https://docs.aws.amazon.com/scheduler/latest/UserGuide/managing-targets-universal.html) rather than service-specific configuration.

## Pre-Commit hooks

[.pre-commit-config.yaml](.pre-commit-config.yaml) file defines certain `pre-commit` hooks that are relevant to terraform, golang and common linting tasks. There are no custom hooks added.

`commitlint` hook enforces commit message in certain format. The commit contains the following structural elements, to communicate intent to the consumers of your commit messages:

- **fix**: a commit of the type `fix` patches a bug in your codebase (this correlates with PATCH in Semantic Versioning).
- **feat**: a commit of the type `feat` introduces a new feature to the codebase (this correlates with MINOR in Semantic Versioning).
- **BREAKING CHANGE**: a commit that has a footer `BREAKING CHANGE:`, or appends a `!` after the type/scope, introduces a breaking API change (correlating with MAJOR in Semantic Versioning). A BREAKING CHANGE can be part of commits of any type.
footers other than BREAKING CHANGE: <description> may be provided and follow a convention similar to git trailer format.
- **build**: a commit of the type `build` adds changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
- **chore**: a commit of the type `chore` adds changes that don't modify src or test files
- **ci**: a commit of the type `ci` adds changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)
- **docs**: a commit of the type `docs` adds documentation only changes
- **perf**: a commit of the type `perf` adds code change that improves performance
- **refactor**: a commit of the type `refactor` adds code change that neither fixes a bug nor adds a feature
- **revert**: a commit of the type `revert` reverts a previous commit
- **style**: a commit of the type `style` adds code changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- **test**: a commit of the type `test` adds missing tests or correcting existing tests

Base configuration used for this project is [commitlint-config-conventional (based on the Angular convention)](https://github.com/conventional-changelog/commitlint/tree/master/@commitlint/config-conventional#type-enum)

If you are a developer using vscode, [this](https://marketplace.visualstudio.com/items?itemName=joshbolduc.commitlint) plugin may be helpful.

`detect-secrets-hook` prevents new secrets from being introduced into the baseline. TODO: INSERT DOC LINK ABOUT HOOKS

In order for `pre-commit` hooks to work properly

- You need to have the pre-commit package manager installed. [Here](https://pre-commit.com/#install) are the installation instructions.
- `pre-commit` would install all the hooks when commit message is added by default except for `commitlint` hook. `commitlint` hook would need to be installed manually using the command below

```
pre-commit install --hook-type commit-msg
```

## To test the resource group module locally

1. For development/enhancements to this module locally, you'll need to install all of its components. This is controlled by the `configure` target in the project's [`Makefile`](./Makefile). Before you can run `configure`, familiarize yourself with the variables in the `Makefile` and ensure they're pointing to the right places.

```
make configure
```

This adds in several files and directories that are ignored by `git`. They expose many new Make targets.

2. _THIS STEP APPLIES ONLY TO MICROSOFT AZURE. IF YOU ARE USING A DIFFERENT PLATFORM PLEASE SKIP THIS STEP._ The first target you care about is `env`. This is the common interface for setting up environment variables. The values of the environment variables will be used to authenticate with cloud provider from local development workstation.

`make configure` command will bring down `azure_env.sh` file on local workstation. Devloper would need to modify this file, replace the environment variable values with relevant values.

These environment variables are used by `terratest` integration suit.

Service principle used for authentication(value of ARM_CLIENT_ID) should have below privileges on resource group within the subscription.

```
"Microsoft.Resources/subscriptions/resourceGroups/write"
"Microsoft.Resources/subscriptions/resourceGroups/read"
"Microsoft.Resources/subscriptions/resourceGroups/delete"
```

Then run this make target to set the environment variables on developer workstation.

```
make env
```

3. The first target you care about is `check`.

**Pre-requisites**
Before running this target it is important to ensure that, developer has created files mentioned below on local workstation under root directory of git repository that contains code for primitives/segments. Note that these files are `azure` specific. If primitive/segment under development uses any other cloud provider than azure, this section may not be relevant.

- A file named `provider.tf` with contents below

```
provider "azurerm" {
  features {}
}
```

- A file named `terraform.tfvars` which contains key value pair of variables used.

Note that since these files are added in `gitignore` they would not be checked in into primitive/segment's git repo.

After creating these files, for running tests associated with the primitive/segment, run

```
make check
```

If `make check` target is successful, developer is good to commit the code to primitive/segment's git repo.

`make check` target

- runs `terraform commands` to `lint`,`validate` and `plan` terraform code.
- runs `conftests`. `conftests` make sure `policy` checks are successful.
- runs `terratest`. This is integration test suit.
- runs `opa` tests
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

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_scheduler_schedule.schedule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/scheduler_schedule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name of the schedule. Changing this value will force creation of a new resource. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | The description of the schedule. | `string` | `null` | no |
| <a name="input_group_name"></a> [group\_name](#input\_group\_name) | Name of the schedule group to associate with this schedule. If not<br/>    specified, the `default` schedule group is used. | `string` | `"default"` | no |
| <a name="input_state"></a> [state](#input\_state) | Specifies whether the schedule is `ENABLED` or `DISABLED`. | `string` | `"ENABLED"` | no |
| <a name="input_start_date"></a> [start\_date](#input\_start\_date) | The date, in UTC, after which the schedule can begin invoking its target.<br/>    Depending on the schedule's recurrence expression, invocations might occur<br/>    on, or after, the start date you specify. EventBridge Scheduler ignores the<br/>    start date for one-time schedules. Omitting this value will allow for<br/>    immediate execution. Example: `2030-01-01T01:00:00Z` | `string` | `null` | no |
| <a name="input_end_date"></a> [end\_date](#input\_end\_date) | The date, in UTC, before which the schedule can invoke its target.<br/>    Depending on the schedule's recurrence expression, invocations might stop<br/>    on, or before, the end date you specify. EventBridge Scheduler ignores the<br/>    end date for one-time schedules. Omitting this value will allow the<br/>    schedule to run indefinitely. Example: `2030-01-01T01:00:00Z`. | `string` | `null` | no |
| <a name="input_schedule_expression"></a> [schedule\_expression](#input\_schedule\_expression) | Defines when the schedule runs. For more information on schedule types,<br/>    as well as details on timezones and DST handling, see Schedule Types:<br/>    https://docs.aws.amazon.com/scheduler/latest/UserGuide/schedule-types.html<br/>    Examples: `cron(0 20 * * ? *)`, `rate(5 minutes)`, `at(2025-01-01T00:00:00)`. | `string` | n/a | yes |
| <a name="input_schedule_expression_timezone"></a> [schedule\_expression\_timezone](#input\_schedule\_expression\_timezone) | The timezone for the schedule. If not specified, the default timezone is `UTC`.<br/>    For more information on timezones and DST handling, see Schedule Types:<br/>    https://docs.aws.amazon.com/scheduler/latest/UserGuide/schedule-types.html | `string` | `"UTC"` | no |
| <a name="input_input"></a> [input](#input\_input) | Optional text or well-formed JSON, passed to the target. The parameters<br/>    and shape of the JSON you set are determined by the service API your<br/>    schedule invokes. To find this information, see the API reference for the<br/>    service you want to target. | `string` | `null` | no |
| <a name="input_flexible_time_window_minutes"></a> [flexible\_time\_window\_minutes](#input\_flexible\_time\_window\_minutes) | The maximum amount of time, in minutes, that the schedule can delay the<br/>    invocation of its target. The value must be between 1 and 1440 minutes.<br/>    If not specified, the schedule will run immediately at its scheduled time. | `number` | `null` | no |
| <a name="input_target_arn"></a> [target\_arn](#input\_target\_arn) | The ARN of the target to invoke. This uses the Universal Target ARN format,<br/>    not the standard ARN of the resource itself. For more details on constructing<br/>    a universal target ARN, see:<br/>    https://docs.aws.amazon.com/scheduler/latest/UserGuide/managing-targets-universal.html#supported-universal-targets.<br/><br/>    Example: `arn:aws:scheduler:::aws-sdk:<service>:<apiAction>` | `string` | n/a | yes |
| <a name="input_target_role_arn"></a> [target\_role\_arn](#input\_target\_role\_arn) | The ARN of the IAM role to assume when invoking the target. This role must<br/>    have the necessary permissions to invoke the target. For more information on<br/>    creating a role for EventBridge Scheduler, see:<br/>    https://docs.aws.amazon.com/scheduler/latest/UserGuide/setting-up.html#setting-up-execution-role.<br/><br/>    When creating an IAM role to handle execution of services from a schedule,<br/>    you should scope the policy to avoid the confused deputy problem:<br/>    https://docs.aws.amazon.com/scheduler/latest/UserGuide/cross-service-confused-deputy-prevention.html<br/><br/>    Example: `arn:aws:iam::123456789012:role/service-role/MySchedulerRole` | `string` | n/a | yes |
| <a name="input_dead_letter_arn"></a> [dead\_letter\_arn](#input\_dead\_letter\_arn) | ARN of the SQS queue specified as the destination for the dead-letter queue. | `string` | `null` | no |
| <a name="input_maximum_event_age_in_seconds"></a> [maximum\_event\_age\_in\_seconds](#input\_maximum\_event\_age\_in\_seconds) | The maximum age of a message in seconds that the schedule can retry.<br/>    If the message is older than this value, the schedule will not retry the<br/>    message. The value ranges between 60 and 86400 seconds (default) | `number` | `null` | no |
| <a name="input_maximum_retry_attempts"></a> [maximum\_retry\_attempts](#input\_maximum\_retry\_attempts) | The number of times the schedule will retry the invocation in case of<br/>    failure. The value ranges between 0 and 185 (default). | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_arn"></a> [arn](#output\_arn) | n/a |
| <a name="output_group_name"></a> [group\_name](#output\_group\_name) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
