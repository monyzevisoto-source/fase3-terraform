resource "aws_sqs_queue" "main" {
  name                       = "${var.project_name}-${var.environment}-${var.queue_name}"
  visibility_timeout_seconds = var.visibility_timeout_seconds
  message_retention_seconds  = var.message_retention_seconds

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-${var.queue_name}"
  })
}
