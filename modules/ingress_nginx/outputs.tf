output "namespace" {
  description = "Namespace where ingress-nginx is installed."
  value       = helm_release.ingress_nginx.namespace
}
