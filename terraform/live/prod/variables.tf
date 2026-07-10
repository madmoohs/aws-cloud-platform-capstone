variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "cluster_name" {
  type    = string
  default = "aws-cloud-platform-capstone-prod"
}

variable "cluster_version" {
  type    = string
  default = "1.32"
}

variable "vpc_cidr" {
  type    = string
  default = "10.2.0.0/16"
}

variable "availability_zones" {
  type    = list(string)
  default = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.2.11.0/24", "10.2.12.0/24", "10.2.13.0/24"]
}

variable "node_instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "node_desired_size" {
  type    = number
  default = 3
}

variable "node_min_size" {
  type    = number
  default = 2
}

variable "node_max_size" {
  type    = number
  default = 10
}