resource "aws_elasticache_subnet_group" "main" {
  name        = "${var.project_name}-${var.environment}-redis"
  description = "Private subnets for the Redis replication group."
  subnet_ids  = var.private_subnet_ids
}

resource "aws_security_group" "redis" {
  name        = "${var.project_name}-${var.environment}-redis"
  description = "Restricts Redis access to the project VPC."
  vpc_id      = var.vpc_id

  ingress {
    description = "Redis from the project VPC"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    description = "Allow outbound traffic required by ElastiCache"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-redis"
  })
}

resource "aws_elasticache_replication_group" "main" {
  replication_group_id       = "${var.project_name}-${var.environment}-redis"
  description                = "Redis cache for ${var.project_name} ${var.environment}."
  engine                     = "redis"
  node_type                  = var.node_type
  num_cache_clusters         = 1
  automatic_failover_enabled = false
  multi_az_enabled           = false
  subnet_group_name          = aws_elasticache_subnet_group.main.name
  security_group_ids         = [aws_security_group.redis.id]
  apply_immediately          = true

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-redis"
  })
}
