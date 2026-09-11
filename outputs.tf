output "vpc_id" {
  description = "Identifier of the VPC created by the network module."
  value       = module.network.vpc_id
}

output "private_subnet_ids" {
  description = "List of private subnets created for the application layer."
  value       = module.network.private_subnet_ids
}

output "eks_cluster_name" {
  description = "Name of the EKS cluster."
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "Endpoint of the EKS cluster."
  value       = module.eks.cluster_endpoint
}

output "eks_node_group_name" {
  description = "Name of the managed EKS node group."
  value       = module.eks.node_group_name
}

output "rds_instance_endpoints" {
  description = "PostgreSQL RDS endpoints keyed by instance name."
  value = {
    auth      = module.rds_auth.endpoint
    flag      = module.rds_flag.endpoint
    analytics = module.rds_analytics.endpoint
  }
}

output "rds_security_group_id" {
  description = "Security group IDs that control PostgreSQL access."
  value = {
    auth      = module.rds_auth.security_group_id
    flag      = module.rds_flag.security_group_id
    analytics = module.rds_analytics.security_group_id
  }
}

output "dynamodb_table_name" {
  description = "DynamoDB table name."
  value       = module.dynamodb.table_name
}

output "dynamodb_table_arn" {
  description = "DynamoDB table ARN."
  value       = module.dynamodb.table_arn
}

output "redis_primary_endpoint" {
  description = "Primary Redis endpoint address."
  value       = module.redis.primary_endpoint_address
}

output "sqs_queue_url" {
  description = "SQS queue URL."
  value       = module.sqs.queue_url
}

output "sqs_queue_arn" {
  description = "SQS queue ARN."
  value       = module.sqs.queue_arn
}

output "ecr_repository_urls" {
  description = "ECR repository URLs keyed by microservice name."
  value = {
    auth       = module.ecr_auth.repository_url
    flag       = module.ecr_flag.repository_url
    targeting  = module.ecr_targeting.repository_url
    evaluation = module.ecr_evaluation.repository_url
    analytics  = module.ecr_analytics.repository_url
  }
}

#output "ecr_repository_url" {
#  description = "URL of the ECR repository created by the data module."
#  value       = module.data.ecr_repository_url
#}
#
#output "eks_cluster_name" {
#  description = "Name of the EKS cluster managed by the EKS module."
#  value       = module.eks.cluster_name
#}

output "argocd_namespace" {
  description = "Namespace where Argo CD is installed."
  value       = module.argocd.namespace
}
