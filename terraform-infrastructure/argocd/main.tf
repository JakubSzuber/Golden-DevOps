resource "kubectl_manifest" "namespace" {
  for_each           = data.kubectl_file_documents.namespace.manifests
  yaml_body          = each.value
  override_namespace = "argocd"
}

resource "kubectl_manifest" "argocd" {
  depends_on = [
    kubectl_manifest.namespace,
  ]
  for_each           = data.kubectl_file_documents.argocd.manifests
  yaml_body          = each.value
  override_namespace = "argocd"
}

resource "kubectl_manifest" "grpc" {
  depends_on = [
    kubectl_manifest.argocd,
  ]
  for_each           = data.kubectl_file_documents.grpc.manifests
  yaml_body          = each.value
  override_namespace = "argocd"
}

resource "kubectl_manifest" "ingress" {
  depends_on = [
    kubectl_manifest.grpc
  ]
  for_each           = data.kubectl_file_documents.ingress.manifests
  yaml_body          = each.value
  override_namespace = "argocd"
}

resource "kubectl_manifest" "app_repos" {
  depends_on = [
    kubectl_manifest.ingress
  ]
  for_each           = data.kubectl_file_documents.repos.manifests
  yaml_body          = each.value
  override_namespace = "argocd"
}

resource "kubectl_manifest" "app_set" {
  depends_on = [
    kubectl_manifest.app_repos
  ]
  for_each           = data.kubectl_file_documents.appset.manifests
  yaml_body          = each.value
  override_namespace = "argocd"
}
