variable "aws_region" {
  description = "AWS region used for all resources."
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS named profile used for authentication. Leave empty to use default environment credentials."
  type        = string
  default     = ""
}

variable "project_name" {
  description = "Project identifier used in tags and resource names."
  type        = string
  default     = "fiap-fase3"
}

variable "environment" {
  description = "Environment name for the deployment."
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Additional tags applied to resources."
  type        = map(string)
  default     = {}
}

variable "eks_lab_role_name" {
  description = "Existing AWS Academy IAM role used by the EKS cluster and node group."
  type        = string
  default     = "LabRole"
}

variable "eks_node_instance_type" {
  description = "EC2 instance type for the initial EKS node group."
  type        = string
  default     = "t3.medium"
}

variable "eks_node_desired_size" {
  description = "Desired number of EKS nodes."
  type        = number
  default     = 1
}

variable "eks_node_min_size" {
  description = "Minimum number of EKS nodes."
  type        = number
  default     = 1
}

variable "eks_node_max_size" {
  description = "Maximum number of EKS nodes."
  type        = number
  default     = 2
}

variable "rds_instance_class" {
  description = "Instance class used by the PostgreSQL RDS instances."
  type        = string
  default     = "db.t3.micro"
}

variable "rds_allocated_storage" {
  description = "Initial storage in GiB for each PostgreSQL RDS instance."
  type        = number
  default     = 20
}

variable "rds_max_allocated_storage" {
  description = "Maximum storage in GiB for each PostgreSQL RDS instance."
  type        = number
  default     = 25
}

variable "rds_master_username" {
  description = "Master username for PostgreSQL; passwords are managed by AWS Secrets Manager."
  type        = string
  default     = "postgresadmin"
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name."
  type        = string
  default     = "ToggleMasterAnalytics"
}

variable "dynamodb_hash_key" {
  description = "DynamoDB partition-key name."
  type        = string
  default     = "id"
}

variable "redis_node_type" {
  description = "ElastiCache node type for Redis."
  type        = string
  default     = "cache.t3.micro"
}

variable "sqs_queue_name" {
  description = "Queue-specific name suffix."
  type        = string
  default     = "events"
}

variable "sqs_visibility_timeout_seconds" {
  description = "SQS message visibility timeout in seconds."
  type        = number
  default     = 30
}

variable "sqs_message_retention_seconds" {
  description = "SQS message retention period in seconds."
  type        = number
  default     = 345600
}

variable "ecr_image_tag_mutability" {
  description = "Whether ECR image tags can be overwritten."
  type        = string
  default     = "MUTABLE"
}

variable "argocd_chart_version" {
  description = "Pinned official Argo CD Helm chart version."
  type        = string
  default     = "10.9.0"
}

variable "ingress_nginx_chart_version" {
  description = "Pinned community ingress-nginx chart version, retained for lab compatibility after project retirement."
  type        = string
  default     = "4.15.1"
}

variable "metrics_server_addon_version" {
  description = "Pinned Metrics Server add-on version, validated for EKS 1.36."
  type        = string
  default     = "v0.9.0-eksbuild.10"
}
