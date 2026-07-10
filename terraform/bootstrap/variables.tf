variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-southeast-1"
}

variable "state_bucket_name" {
  description = "Terraform State Bucket"
  type        = string
}

variable "lock_table_name" {
  description = "Terraform Lock Table"
  type        = string
}