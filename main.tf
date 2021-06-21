/**
 * # ECS Scheduled Tasks
 *
 * ## Description
 *
 * This module runs an ECS task in Fargate based on an Event Bridge Rule.
 *
 * ## Usage
 *
 * ```hcl
 * module "ecs-scheduled-task" {
 *   source = "dod-iac/ecs-scheduled-task/aws"
 *
 *   name = "task-name"
 *   schedule_expression = "cron(30 * * * ? *)"
 *
 *   ecs_cluster_arn = aws_ecs_cluster.cluster.arn
 *   ecs_subnets     = var.ecs_subnets
 *   vpc_id          = var.vpc_id
 *
 *   ecr_repository_arn = module.ecr_repo.arn
 *   ecr_repository_url = module.ecr_repo.repository_url
 *   image_tag          = data.aws_ssm_parameter.image_tag.value
 *
 *   cloudwatch_log_group_arn  = aws_cloudwatch_log_group.main.arn
 *   cloudwatch_log_group_name = aws_cloudwatch_log_group.main.name
 *
 *   task_role_policy_doc = data.aws_iam_policy_document.task_role_policy_doc.json
 *
 *   task_def_env_vars = [
 *     { "name" : "KEYNAME1", "value" : "VALUE1" },
 *     { "name" : "KEYNAME2", "value" : "VALUE2" },
 *   ]
 *
 *   tags = {
 *     Project     = var.project
 *     Application = var.application
 *     Environment = var.environment
 *     Automation  = "Terraform"
 *   }
 * }
 * ```
 *
 * ## Terraform Version
 *
 * Terraform 0.13. Pin module version to ~> 1.0.0 . Submit pull-requests to master branch.
 *
 * ## License
 *
 * This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105.  However, because the project utilizes code licensed from contributors and other third parties, it therefore is licensed under the MIT License.  See LICENSE file for more information.
 *
 * ## Developer Setup
 *
 * This template is configured to use aws-vault, direnv, pre-commit, terraform-docs, and tfenv.  If using Homebrew on macOS, you can install the dependencies using the following code.
 *
 * ```shell
 * brew install aws-vault direnv pre-commit terraform-docs tfenv
 * pre-commit install --install-hooks
 * ```
 *
 * If using `direnv`, add a `.envrc.local` that sets the default AWS region, e.g., `export AWS_DEFAULT_REGION=us-west-2`.
 *
 * If using `tfenv`, then add a `.terraform-version` to the project root dir, with the version you would like to use.
 *
 *
 */

data "aws_caller_identity" "current" {}
data "aws_iam_account_alias" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}
