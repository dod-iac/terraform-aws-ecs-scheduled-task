
output "task_role_arn" {
  value       = aws_iam_role.task_role.arn
  description = "ECS task IAM role arn"
}

output "task_execution_role_arn" {
  value       = aws_iam_role.task_execution_role.arn
  description = "ECS task execution IAM role arn"
}

output "cloudwatch_target_role_arn" {
  value       = aws_iam_role.cloudwatch_target_role.arn
  description = "CloudWatch target IAM role arn"
}

output "event_rule_run_command_arn" {
  value       = aws_cloudwatch_event_rule.run_command.arn
  description = "CloudWatch event rule run commandarn"
}
