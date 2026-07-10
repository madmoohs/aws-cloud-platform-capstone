provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.cluster_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Repository  = "aws-cloud-platform-capstone"
    }
  }
}