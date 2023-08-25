module "lb_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                              = "aws-load-balancer-controller-${terraform.workspace}"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller-${terraform.workspace}"]
    }
  }

  # TODO Uncomment those 3 lines when Karpenter will be finished
  depends_on = [
    module.eks#,
    #kubectl_manifest.karpenter_node_template,
    #kubectl_manifest.karpenter_provisioner
  ]
}

resource "kubernetes_service_account" "lb-service-account" {
  metadata {
    name      = "aws-load-balancer-controller-${terraform.workspace}"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name"      = "aws-load-balancer-controller-${terraform.workspace}"
      "app.kubernetes.io/component" = "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn"               = module.lb_role.iam_role_arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
  depends_on = [
    module.lb_role
  ]
}

resource "helm_release" "lb" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  depends_on = [
    kubernetes_service_account.lb-service-account
  ]

  set {
    name  = "region"
    value = var.region
  }

  set {
    name  = "vpcId"
    value = data.terraform_remote_state.vpc.outputs.vpc_id
  }

  set {
    name  = "image.repository"
    value = "${var.aws_image_repository}/amazon/aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller-${terraform.workspace}"
  }

  set {
    name  = "clusterName"
    value = module.eks.cluster_id
  }
}
