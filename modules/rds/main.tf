resource "aws_db_subnet_group" "postgresql" {
  name        = "${var.project_name}-${var.environment}-${var.instance_name}-postgresql"
  description = "Private subnets for the ${var.instance_name} PostgreSQL RDS instance."
  subnet_ids  = var.private_subnet_ids

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-${var.instance_name}-postgresql"
  })
}

resource "aws_security_group" "postgresql" {
  name        = "${var.project_name}-${var.environment}-${var.instance_name}-postgresql"
  description = "Restricts access to the ${var.instance_name} PostgreSQL instance."
  vpc_id      = var.vpc_id

  ingress {
    description = "PostgreSQL from the project VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    description = "Allow outbound traffic required by RDS"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-${var.instance_name}-postgresql"
  })
}

resource "aws_db_instance" "postgresql" {
  identifier                  = "${var.project_name}-${var.environment}-${var.instance_name}-postgresql"
  allocated_storage           = var.allocated_storage
  max_allocated_storage       = var.max_allocated_storage
  engine                      = "postgres"
  instance_class              = var.instance_class
  db_name                     = var.database_name
  username                    = var.master_username
  manage_master_user_password = var.manage_master_user_password ? true : null
  password_wo                 = var.master_password_wo
  password_wo_version         = var.master_password_wo_version
  db_subnet_group_name        = aws_db_subnet_group.postgresql.name
  vpc_security_group_ids      = [aws_security_group.postgresql.id]
  publicly_accessible         = false
  multi_az                    = false
  storage_encrypted           = true
  backup_retention_period     = 0
  deletion_protection         = false
  skip_final_snapshot         = true
  apply_immediately           = true
  auto_minor_version_upgrade  = true
  copy_tags_to_snapshot       = true

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-${var.instance_name}-postgresql"
  })
}
