variable "chart_version" {
  description = "Pinned community ingress-nginx Helm chart version."
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for the internet-facing Network Load Balancer."
  type        = list(string)
}

variable "tags" {
  description = "AWS tags applied to the Network Load Balancer."
  type        = map(string)
}
