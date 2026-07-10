# Development Environment

This directory provisions the complete AWS development platform.

## Resources

- Amazon VPC
- Public Subnets
- Private Subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- Amazon EKS
- Managed Node Group
- IAM Roles
- OIDC Provider
- EKS Addons

## Remote State

- Amazon S3
- Amazon DynamoDB

## Deployment

```bash
terraform init

terraform fmt -recursive

terraform validate

terraform plan

terraform apply
```

## Configure kubectl

```bash
aws eks update-kubeconfig \
  --region ap-southeast-1 \
  --name aws-cloud-platform-capstone-dev

kubectl get nodes
```