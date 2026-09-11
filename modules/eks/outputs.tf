output "cluster_name" {
  description = "EKS cluster name."
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint."
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_arn" {
  description = "EKS cluster ARN."
  value       = aws_eks_cluster.main.arn
}

output "node_group_name" {
  description = "Managed EKS node group name."
  value       = aws_eks_node_group.main.node_group_name
}

output "cluster_certificate_authority_data" {
  description = "Base64-encoded Kubernetes API CA certificate."
  value       = aws_eks_cluster.main.certificate_authority[0].data
}
