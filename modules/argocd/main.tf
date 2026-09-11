resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = "argocd"
  create_namespace = true
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.chart_version
  atomic           = true
  cleanup_on_fail  = true
  wait             = true
  timeout          = 900
  values = [yamlencode({
    server = {
      service = { type = "ClusterIP" }
    }
  })]
}
