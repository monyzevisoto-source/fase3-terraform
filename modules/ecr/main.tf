resource "aws_ecr_repository" "main" {
  name                 = "${var.project_name}-${var.environment}-${var.service_name}"
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(var.tags, {
    Name        = "${var.project_name}-${var.environment}-${var.service_name}"
    ServiceName = var.service_name
  })
}
