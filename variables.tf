
variable "name" {
  type        = string
  default     = "scheduled-task"
  description = "A unique name for the module"
}

variable "tags" {
  type        = map
  default     = {}
  description = "tags for resources"
}

#
# Extra variables
#

variable "cloudwatch_log_group_arn" {
  type        = string
  description = "The arn of the cloudwatch log group"
}

variable "cloudwatch_log_group_name" {
  type        = string
  description = "The name of the cloudwatch log group"
}

variable "ecs_subnets" {
  type        = list(string)
  description = "The list of subnets to use for the ECS tasks."
}

# CPU/MEM values are here: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html

variable "ecs_task_cpu" {
  type    = number
  default = 2048
}

variable "ecs_task_mem" {
  type    = number
  default = 4096
}

variable "ecs_cluster_arn" {
  type        = string
  description = "The ECS cluster arn"
}

variable "schedule_expression" {
  type        = string
  default     = "cron(30 * * * ? *)" # every half hour
  description = "The schedule to run the task on in AWS cron format."
}

variable "image_tag" {
  type        = string
  description = "The image tag to deploy"
}

variable "vpc_id" {
  type        = string
  description = "The vpc ID related to the subnets."
}

variable "task_role_policy_doc" {
  type        = string
  description = "The IAM policy document used for the task role"
}

variable "task_def_env_vars" {
  type        = list(map(string))
  description = "Environment variables for the task definition"
  default     = []
}

variable "ecr_repository_url" {
  type        = string
  description = "The ECR repository URL"
}

variable "ecr_repository_arn" {
  type        = string
  description = "The ECR repository arn"
}
