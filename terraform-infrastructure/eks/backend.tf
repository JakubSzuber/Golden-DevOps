terraform {
  backend "s3" {
    bucket = "golden-devops-bucket-demo"
    #key    = "k8-demo-eks.tfstate"
    #key    = "env:/${terraform.workspace}/k8-demo-eks.tfstate"  # TODO
    key    = "eks.tfstate"
    region = "us-east-1"
  }
}