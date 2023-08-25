output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_iam_role_arn" {
  value = module.eks.cluster_iam_role_arn
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "cluster_id" {
  value = module.eks.cluster_id
}

output "cluster_name" {
  value = var.cluster_name
}
