terraform {
  required_version = ">=1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
    }
  }
}

############################
# VPC
############################

module "vpc" {

  source = "terraform-aws-modules/vpc/aws"

  version = "~> 5.8"

  name = var.cluster_name

  cidr = var.vpc_cidr

  azs = var.availability_zones

  private_subnets = var.private_subnets

  public_subnets = var.public_subnets

  enable_nat_gateway = true

  single_nat_gateway = true

  enable_dns_hostnames = true

  enable_dns_support = true

  public_subnet_tags = {

    "kubernetes.io/role/elb" = "1"

  }

  private_subnet_tags = {

    "kubernetes.io/role/internal-elb" = "1"

  }

}

############################
# EKS
############################

module "eks" {

  source = "terraform-aws-modules/eks/aws"

  version = "~> 20.0"

  cluster_name = var.cluster_name

  cluster_version = var.kubernetes_version

  cluster_endpoint_public_access = true

  subnet_ids = module.vpc.private_subnets

  vpc_id = module.vpc.vpc_id

  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {

    default = {

      instance_types = ["t3.medium"]

      desired_size = var.desired_size

      min_size = var.min_size

      max_size = var.max_size

      capacity_type = "ON_DEMAND"

    }

  }

  tags = {

    Project = "AWS Cloud Platform Capstone"

    Terraform = "true"

  }

}