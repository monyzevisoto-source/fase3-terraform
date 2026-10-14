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

resource "helm_release" "root_application" {
  name            = "argocd-root-application"
  namespace       = helm_release.argocd.namespace
  chart           = "${path.module}/root-application-chart"
  atomic          = true
  cleanup_on_fail = true
  wait            = true
  values = [yamlencode({
    gitopsRepositoryUrl = var.gitops_repository_url
  })]

  depends_on = [helm_release.argocd]
}
