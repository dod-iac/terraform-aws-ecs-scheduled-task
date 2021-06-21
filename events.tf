
data "aws_iam_policy_document" "events_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

### CloudWatch Target IAM

data "aws_iam_policy_document" "cloudwatch_target_role_policy_doc" {
  statement {
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = ["*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["ecs:RunTask"]
    resources = aws_ecs_task_definition.task_def.*.arn
    condition {
      test     = "StringLike"
      variable = "ecs:cluster"
      values = [
        var.ecs_cluster_arn,
      ]
    }
  }
}

resource "aws_iam_role" "cloudwatch_target_role" {
  name               = format("cw-target-role-%s", var.name)
  description        = format("Role allowing CloudWatch Events to run the %s task", var.name)
  assume_role_policy = data.aws_iam_policy_document.events_assume_role_policy.json
}

resource "aws_iam_role_policy" "cloudwatch_target_role_policy" {
  name   = format("%s-policy", aws_iam_role.cloudwatch_target_role.name)
  role   = aws_iam_role.cloudwatch_target_role.name
  policy = data.aws_iam_policy_document.cloudwatch_target_role_policy_doc.json
}

#
# CloudWatch
#

resource "aws_cloudwatch_event_rule" "run_command" {
  name                = var.name
  description         = format("Scheduled task for %s", var.name)
  schedule_expression = var.schedule_expression
}

resource "aws_security_group" "outbound" {

  name        = format("allow-outbound-%s", var.name)
  description = format("Allow outbound traffic for %s", var.name)

  vpc_id = var.vpc_id

  // Ingress on 443 required
  // https://docs.aws.amazon.com/AmazonECR/latest/userguide/vpc-endpoints.html
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:AWS008
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:AWS009
  }

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "ecs_task" {

  target_id = format("run-task-%s", var.name)
  arn       = var.ecs_cluster_arn
  rule      = aws_cloudwatch_event_rule.run_command.name
  role_arn  = aws_iam_role.cloudwatch_target_role.arn

  ecs_target {
    launch_type = "FARGATE"
    task_count  = 1

    # Use latest active revision
    task_definition_arn = aws_ecs_task_definition.task_def.arn

    network_configuration {
      subnets          = var.ecs_subnets
      security_groups  = [aws_security_group.outbound.id]
      assign_public_ip = true # Without this set to True the image cannot be pulled
    }
  }
}
