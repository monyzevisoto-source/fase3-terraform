resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = var.chart_version
  atomic           = true
  cleanup_on_fail  = true
  wait             = true
  timeout          = 900

  values = [yamlencode({
    controller = {
      replicaCount = 2
      ingressClass = "nginx"
      ingressClassResource = {
        name    = "nginx"
        enabled = true
        default = false
      }
      allowSnippetAnnotations = false
      service = {
        type                  = "LoadBalancer"
        externalTrafficPolicy = "Local"
        annotations = {
          "service.beta.kubernetes.io/aws-load-balancer-type"                     = "nlb"
          "service.beta.kubernetes.io/aws-load-balancer-subnets"                  = join(",", var.public_subnet_ids)
          "service.beta.kubernetes.io/aws-load-balancer-additional-resource-tags" = join(",", [for key, value in var.tags : "${key}=${value}"])
        }
      }
    }
  })]
}
