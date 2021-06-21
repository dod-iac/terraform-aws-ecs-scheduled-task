<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
# ECS Scheduled Tasks

## Description

This module runs an ECS task in Fargate based on an Event Bridge Rule.

## Usage

```hcl
module "ecs-scheduled-task" {
  source = "dod-iac/ecs-scheduled-task/aws"

  name = "task-name"
  schedule_expression = "cron(30 * * * ? *)"

  ecs_cluster_arn = aws_ecs_cluster.cluster.arn
  ecs_subnets     = var.ecs_subnets
  vpc_id          = var.vpc_id

  ecr_repository_arn = module.ecr_repo.arn
  ecr_repository_url = module.ecr_repo.repository_url
  image_tag          = data.aws_ssm_parameter.image_tag.value

  cloudwatch_log_group_arn  = aws_cloudwatch_log_group.main.arn
  cloudwatch_log_group_name = aws_cloudwatch_log_group.main.name

  task_role_policy_doc = data.aws_iam_policy_document.task_role_policy_doc.json

  task_def_env_vars = [
    { "name" : "KEYNAME1", "value" : "VALUE1" },
    { "name" : "KEYNAME2", "value" : "VALUE2" },
  ]

  tags = {
    Project     = var.project
    Application = var.application
    Environment = var.environment
    Automation  = "Terraform"
  }
}
```

## Terraform Version

Terraform 0.13. Pin module version to ~> 1.0.0 . Submit pull-requests to master branch.

## License

This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105.  However, because the project utilizes code licensed from contributors and other third parties, it therefore is licensed under the MIT License.  See LICENSE file for more information.

## Developer Setup

This template is configured to use aws-vault, direnv, pre-commit, terraform-docs, and tfenv.  If using Homebrew on macOS, you can install the dependencies using the following code.

```shell
brew install aws-vault direnv pre-commit terraform-docs tfenv
pre-commit install --install-hooks
```

If using `direnv`, add a `.envrc.local` that sets the default AWS region, e.g., `export AWS_DEFAULT_REGION=us-west-2`.

If using `tfenv`, then add a `.terraform-version` to the project root dir, with the version you would like to use.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.run_command](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.ecs_task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_ecs_task_definition.task_def](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.cloudwatch_target_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.task_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.cloudwatch_target_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.task_execution_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.task_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_security_group.outbound](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_account_alias.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_account_alias) | data source |
| [aws_iam_policy_document.cloudwatch_target_role_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.events_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.task_execution_role_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_log_group_arn"></a> [cloudwatch\_log\_group\_arn](#input\_cloudwatch\_log\_group\_arn) | The arn of the cloudwatch log group | `string` | n/a | yes |
| <a name="input_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#input\_cloudwatch\_log\_group\_name) | The name of the cloudwatch log group | `string` | n/a | yes |
| <a name="input_ecr_repository_arn"></a> [ecr\_repository\_arn](#input\_ecr\_repository\_arn) | The ECR repository arn | `string` | n/a | yes |
| <a name="input_ecr_repository_url"></a> [ecr\_repository\_url](#input\_ecr\_repository\_url) | The ECR repository URL | `string` | n/a | yes |
| <a name="input_ecs_cluster_arn"></a> [ecs\_cluster\_arn](#input\_ecs\_cluster\_arn) | The ECS cluster arn | `string` | n/a | yes |
| <a name="input_ecs_subnets"></a> [ecs\_subnets](#input\_ecs\_subnets) | The list of subnets to use for the ECS tasks. | `list(string)` | n/a | yes |
| <a name="input_ecs_task_cpu"></a> [ecs\_task\_cpu](#input\_ecs\_task\_cpu) | n/a | `number` | `2048` | no |
| <a name="input_ecs_task_mem"></a> [ecs\_task\_mem](#input\_ecs\_task\_mem) | n/a | `number` | `4096` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | The image tag to deploy | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | A unique name for the module | `string` | `"scheduled-task"` | no |
| <a name="input_schedule_expression"></a> [schedule\_expression](#input\_schedule\_expression) | The schedule to run the task on in AWS cron format. | `string` | `"cron(30 * * * ? *)"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | tags for resources | `map` | `{}` | no |
| <a name="input_task_def_env_vars"></a> [task\_def\_env\_vars](#input\_task\_def\_env\_vars) | Environment variables for the task definition | `list(map(string))` | `[]` | no |
| <a name="input_task_role_policy_doc"></a> [task\_role\_policy\_doc](#input\_task\_role\_policy\_doc) | The IAM policy document used for the task role | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The vpc ID related to the subnets. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudwatch_target_role_arn"></a> [cloudwatch\_target\_role\_arn](#output\_cloudwatch\_target\_role\_arn) | CloudWatch target IAM role arn |
| <a name="output_event_rule_run_command_arn"></a> [event\_rule\_run\_command\_arn](#output\_event\_rule\_run\_command\_arn) | CloudWatch event rule run commandarn |
| <a name="output_task_execution_role_arn"></a> [task\_execution\_role\_arn](#output\_task\_execution\_role\_arn) | ECS task execution IAM role arn |
| <a name="output_task_role_arn"></a> [task\_role\_arn](#output\_task\_role\_arn) | ECS task IAM role arn |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
