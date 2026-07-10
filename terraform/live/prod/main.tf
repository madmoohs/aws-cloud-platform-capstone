module "cluster" {

  source = "../../modules/cluster"

  aws_region = var.aws_region

  environment = var.environment

  cluster_name = var.cluster_name

}