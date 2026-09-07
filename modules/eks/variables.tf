variable "project_name" {
  description = "Project identifier used in EKS resource names."
  type        = string
}

variable "environment" {
  description = "Environment name for the EKS resources."
  type        = string
}

variable "region" {
  description = "AWS region where the EKS resources are created."
  type        = string
}

variable "tags" {
  description = "Tags applied to EKS resources."
  type        = map(string)
}

variable "subnet_ids" {
  description = "Subnet IDs used by the EKS control plane and node group."
  type        = list(string)
}

variable "lab_role_name" {
  description = "Name of the pre-existing AWS Academy IAM role used by EKS and its nodes."
  type        = string
  default     = "LabRole"
}

variable "node_instance_type" {
  description = "EC2 instance type for the managed EKS node group."
  type        = string
  default     = "t3.medium"
}

variable "node_desired_size" {
  description = "Desired number of nodes in the managed node group."
  type        = number
  default     = 1
}

variable "node_min_size" {
  description = "Minimum number of nodes in the managed node group."
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum number of nodes in the managed node group."
  type        = number
  default     = 2
}
