output "endpoint" {
  description = "PostgreSQL endpoint."
  value       = aws_db_instance.postgresql.endpoint
}

output "arn" {
  description = "PostgreSQL RDS ARN."
  value       = aws_db_instance.postgresql.arn
}

output "security_group_id" {
  description = "Security group ID controlling PostgreSQL access."
  value       = aws_security_group.postgresql.id
}
