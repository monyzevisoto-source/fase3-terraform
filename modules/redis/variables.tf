variable "project_name" {
  description = "Project identifier used in Redis resource names."
  type        = string
}

variable "environment" {
  description = "Environment name for the Redis resources."
  type        = string
}

variable "tags" {
  description = "Tags applied to Redis resources."
  type        = map(string)
}

variable "vpc_id" {
  description = "VPC ID where the Redis security group is created."
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block allowed to connect to Redis."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs used by the Redis subnet group."
  type        = list(string)
}

variable "node_type" {
  description = "ElastiCache node type sized for the AWS Academy laboratory."
  type        = string
  default     = "cache.t3.micro"
}
