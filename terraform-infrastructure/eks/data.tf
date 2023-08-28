data "aws_caller_identity" "current" {}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket          = "golden-devops-bucket"
    #key    = "k8-demo-vpc.tfstate"
    #key    = "vpc.tfstate"
    key             = "env:/${terraform.workspace}/vpc.tfstate"
    region          = "us-east-1"
    dynamodb_table  = "golden-devops-dynamodb"
    encrypt         = true
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
