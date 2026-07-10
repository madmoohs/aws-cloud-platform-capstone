module "cluster" {
  source = "../../modules/cluster"

  aws_region          = var.aws_region
  environment         = var.environment
  cluster_name        = var.cluster_name
  cluster_version     = var.cluster_version
  vpc_cidr            = var.vpc_cidr
  availability_zones  = var.availability_zones
  public_subnets      = var.public_subnets
  private_subnets     = var.private_subnets
  node_instance_types = var.node_instance_types
  node_desired_size   = var.node_desired_size
  node_min_size       = var.node_min_size
  node_max_size       = var.node_max_size
}