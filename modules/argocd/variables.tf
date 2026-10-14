variable "chart_version" {
  description = "Official Argo CD Helm chart version."
  type        = string
}

variable "gitops_repository_url" {
  description = "Git repository containing the Argo CD root and child Applications."
  type        = string
}
