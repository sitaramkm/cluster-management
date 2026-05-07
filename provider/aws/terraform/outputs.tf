output "cluster_name" {
  value = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "cluster_oidc_issuer_url" {
  value = var.enable_oidc ? aws_eks_cluster.main.identity[0].oidc[0].issuer : ""
}

output "cluster_certificate_authority_data" {
  description = "Base64-encoded CA cert. Retrieve with: terraform output -raw cluster_certificate_authority_data"
  value       = aws_eks_cluster.main.certificate_authority[0].data
  sensitive   = true
}

output "aws_region" {
  value = var.aws_region
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "node_role_arn" {
  value = aws_iam_role.node.arn
}

output "cluster_role_arn" {
  value = aws_iam_role.cluster.arn
}

output "oidc_provider_arn" {
  value = var.enable_oidc ? aws_iam_openid_connect_provider.cluster[0].arn : ""
}
