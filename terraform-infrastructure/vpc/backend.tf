terraform {
  backend "s3" {
    bucket = "golden-devops-bucket-demo"
    #key    = "k8-demo-vpc.tfstate"
    #key    = "env:/${terraform.workspace}/k8-demo-vpc.tfstate"  # TODO
    key    = "vpc.tfstate"
    region = "us-east-1"
  }
}