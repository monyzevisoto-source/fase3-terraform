output "primary_endpoint_address" {
  description = "Primary Redis endpoint address."
  value       = aws_elasticache_replication_group.main.primary_endpoint_address
}

output "security_group_id" {
  description = "Security group ID controlling Redis access."
  value       = aws_security_group.redis.id
}
