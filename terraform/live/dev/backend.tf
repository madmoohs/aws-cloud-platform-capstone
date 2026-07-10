terraform {

  backend "s3" {

    bucket = "aws-cloud-platform-capstone-tfstate"

    key = "dev/terraform.tfstate"

    region = "ap-southeast-1"

    dynamodb_table = "aws-cloud-platform-capstone-locks"

    encrypt = true
  }

}