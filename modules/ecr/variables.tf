variable "project_name" {
  description = "Project identifier used in the ECR repository name."
  type        = string
}

variable "environment" {
  description = "Environment name used in the ECR repository name."
  type        = string
}

variable "service_name" {
  description = "Microservice name associated with this ECR repository."
  type        = string
}

variable "image_tag_mutability" {
  description = "Whether image tags can be overwritten."
  type        = string
  default     = "MUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "image_tag_mutability must be MUTABLE or IMMUTABLE."
  }
}

variable "tags" {
  description = "Tags applied to the ECR repository."
  type        = map(string)
}
