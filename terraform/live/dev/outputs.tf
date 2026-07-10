output "cluster_name" {
  value = module.cluster.cluster_name
}

output "cluster_endpoint" {
  value = module.cluster.cluster_endpoint
}

output "cluster_version" {
  value = module.cluster.cluster_version
}

output "cluster_security_group_id" {
  value = module.cluster.cluster_security_group_id
}

output "oidc_provider_arn" {
  value = module.cluster.oidc_provider_arn
}

output "vpc_id" {
  value = module.cluster.vpc_id
}

output "private_subnets" {
  value = module.cluster.private_subnets
}

output "public_subnets" {
  value = module.cluster.public_subnets
}

output "alb_controller_role_arn" {
  value = module.cluster.alb_controller_role_arn
}