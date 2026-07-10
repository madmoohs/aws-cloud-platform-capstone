variable "cluster_name" {}

variable "kubernetes_version" {}

variable "vpc_cidr" {}

variable "availability_zones" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "desired_size" {}

variable "min_size" {}

variable "max_size" {}