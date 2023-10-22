locals {
  account_id = data.aws_caller_identity.current.account_id
  tags = {
    Name      = "${var.cluster_name}"
    Project   = "golden-devops"
    ManagedBy = "terraform"
  }
}

module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  version                         = "19.17.1"
  cluster_name                    = var.cluster_name
  cluster_version                 = var.cluster_version
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  enable_irsa                     = true
  cluster_enabled_log_types       = ["api", "authenticator", "audit", "scheduler", "controllerManager"]

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id     = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.vpc.outputs.public_subnets

  #manage_aws_auth_configmap = true

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::${local.account_id}:user/jakubszuber-admin"
      username = "cluster-admin"
      groups   = ["system:masters"]
    },
  ]

  cluster_endpoint_public_access_cidrs = ["5.184.0.0/15", "31.60.0.0/14", "37.47.0.0/16", "37.108.0.0/16", "37.225.0.0/16", "46.134.0.0/16"]

  eks_managed_node_groups = {
    bottlerocket_nodes = {
      ami_type = "BOTTLEROCKET_x86_64"
      # You can uncomment below line to specify concrete size(s) of the nodes that you want to possibly use
      #instance_types = ["t3.micro", "m5.4xlarge", "m5n.large", "c7g.medium"]
      platform      = "bottlerocket"
      min_size      = 1
      max_size      = 2
      desired_size  = 1 # TODO change those 3 numbers
      capacity_type = "SPOT"

      # this will get added to what AWS provides
      bootstrap_extra_args = <<-EOT
      # extra args added
      [settings.kernel]
      lockdown = "integrity"
      EOT
    }
  }
}
