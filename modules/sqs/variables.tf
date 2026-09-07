variable "project_name" {
  description = "Project identifier used in the SQS queue name."
  type        = string
}

variable "environment" {
  description = "Environment name used in the SQS queue name."
  type        = string
}

variable "queue_name" {
  description = "Queue-specific name suffix."
  type        = string
  default     = "events"
}

variable "visibility_timeout_seconds" {
  description = "Time a received message stays invisible before it can be received again."
  type        = number
  default     = 30
}

variable "message_retention_seconds" {
  description = "How long SQS retains messages."
  type        = number
  default     = 345600
}

variable "tags" {
  description = "Tags applied to the SQS queue."
  type        = map(string)
}
