output "namespace" {
  description = "Namespace where Argo CD is installed."
  value       = helm_release.argocd.namespace
}
