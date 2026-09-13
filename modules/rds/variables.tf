variable "project_name" {
  description = "Project identifier used in RDS resource names."
  type        = string
}

variable "environment" {
  description = "Environment name for the RDS resources."
  type        = string
}

variable "tags" {
  description = "Tags applied to RDS resources."
  type        = map(string)
}

variable "vpc_id" {
  description = "VPC ID where the PostgreSQL security group is created."
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block allowed to connect to PostgreSQL."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs used by the RDS subnet group."
  type        = list(string)
}

variable "instance_name" {
  description = "Name used to identify this PostgreSQL instance."
  type        = string
}

variable "database_name" {
  description = "Initial PostgreSQL database name created in the RDS instance."
  type        = string
}

variable "instance_class" {
  description = "RDS instance class sized for the AWS Academy laboratory."
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Initial allocated storage in GiB for each PostgreSQL instance."
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Maximum autoscaled storage in GiB for each PostgreSQL instance."
  type        = number
  default     = 25
}

variable "master_username" {
  description = "Master username; the password is generated and stored by AWS Secrets Manager."
  type        = string
  default     = "postgresadmin"
}

variable "manage_master_user_password" {
  description = "Whether RDS manages the master password. When false, provision and rotate the password externally."
  type        = bool
  default     = true
}

variable "master_password_wo" {
  description = "Externally managed master password, omitted from plans and state."
  type        = string
  sensitive   = true
  ephemeral   = true
  default     = null
}

variable "master_password_wo_version" {
  description = "Increment when applying a new externally managed master password."
  type        = number
  default     = null
}
