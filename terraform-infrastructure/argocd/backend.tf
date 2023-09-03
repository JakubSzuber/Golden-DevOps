terraform {
  backend "s3" {
    bucket          = "golden-devops-bucket"
    key             = "argocd.tfstate"
    region          = "us-east-1"
    dynamodb_table  = "golden-devops-dynamodb"
    encrypt         = true
  }
}
