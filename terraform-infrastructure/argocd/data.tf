data "terraform_remote_state" "eks" {
  backend = "s3"

  config = {
    bucket = "golden-devops-bucket-demo"
    #key    = "k8-demo-eks.tfstate"
    #key    = "env:/${terraform.workspace}/k8-demo-eks.tfstate"  # TODO
    key    = "env:/${terraform.workspace}/eks.tfstate"
    region = "us-east-1"
  }
}

data "kubectl_file_documents" "namespace" {
  content = file("${path.module}/manifests/namespace.yaml")
}

#data "kubectl_file_documents" "secret" {
#  content = file("${path.module}/manifests/secret.yaml")
#}

data "kubectl_file_documents" "argocd" {
  content = file("${path.module}/manifests/install.yaml")
}

data "kubectl_file_documents" "grpc" {
  content = file("${path.module}/manifests/service-grpc.yaml")
}

data "kubectl_file_documents" "repos" {
  content = file("${path.module}/manifests/app-repos.yaml")
}

data "kubectl_file_documents" "ingress" {
  content = templatefile("${path.module}/manifests/ingress.tpl", 
  { env_prefix = terraform.workspace == "prod" ? "" : format("%s.", terraform.workspace) })
}

data "kubectl_file_documents" "appset" {
  content = templatefile("${path.module}/manifests/app-set.tpl", 
  { env_prefix = format("%s.", terraform.workspace) })
}
