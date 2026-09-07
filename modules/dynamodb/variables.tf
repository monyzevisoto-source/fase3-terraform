variable "table_name" {
  description = "Name of the DynamoDB table."
  type        = string
  default     = "ToggleMasterAnalytics"
}

variable "hash_key" {
  description = "Name of the String partition key."
  type        = string
  default     = "id"
}

variable "tags" {
  description = "Tags applied to the DynamoDB table."
  type        = map(string)
}
