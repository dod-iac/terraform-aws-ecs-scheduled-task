

data "aws_iam_policy_document" "ecs_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

### ECS Task Execution Role https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html
# Allows ECS to Pull down the ECR Image and write Logs to CloudWatch

data "aws_iam_policy_document" "task_execution_role_policy_doc" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      var.cloudwatch_log_group_arn,
      format("%s:log-stream:*", var.cloudwatch_log_group_arn),
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
    ]

    resources = [var.ecr_repository_arn]
  }
}

resource "aws_iam_role" "task_execution_role" {
  name               = format("ecs-exec-role-%s", var.name)
  description        = format("Role allowing ECS tasks to execute %s task", var.name)
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json
}

resource "aws_iam_role_policy" "task_execution_role_policy" {
  name   = format("%s-policy", aws_iam_role.task_execution_role.name)
  role   = aws_iam_role.task_execution_role.name
  policy = data.aws_iam_policy_document.task_execution_role_policy_doc.json
}

### ECS Task Role
# Allows ECS to start the task

resource "aws_iam_role" "task_role" {
  name               = format("ecs-role-%s", var.name)
  description        = format("Role allowing container definition to execute %s task", var.name)
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json
}

resource "aws_iam_role_policy" "task_role_policy" {
  name   = format("%s-policy", aws_iam_role.task_role.name)
  role   = aws_iam_role.task_role.name
  policy = var.task_role_policy_doc
}
