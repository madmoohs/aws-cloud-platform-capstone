# Terraform

Infrastructure as Code for the AWS Cloud Platform.

## Structure

```
terraform/
├── bootstrap/          # S3 backend & DynamoDB lock table
├── modules/
│   └── cluster/        # Reusable VPC + EKS + ALB IAM module
└── live/
    ├── dev/            # Development environment
    ├── staging/        # Staging environment
    └── prod/           # Production environment
```

## Resources Provisioned

- **VPC** with public/private subnets, Internet Gateway, NAT Gateway, Route Tables
- **EKS Cluster** with managed node groups, IRSA, cluster logging
- **IAM Roles** for EKS, node groups, and ALB Controller
- **OIDC Provider** for IRSA
- **EKS Addons**: CoreDNS, kube-proxy, vpc-cni, eks-pod-identity-agent
- **S3 Backend** for Terraform state
- **DynamoDB** for state locking

## Deployment Order

### 1. Bootstrap

```bash
cd terraform/bootstrap
terraform init
terraform apply
```

### 2. Environment

```bash
cd terraform/live/dev
terraform init
terraform plan
terraform apply
```

## Interview Talking Points

- **Why modules?** Reusability across dev/staging/prod with consistent configuration
- **Why S3 + DynamoDB?** Remote state with locking prevents corruption and enables team collaboration
- **Why IRSA?** Fine-grained IAM permissions for Kubernetes pods without static credentials
- **Why managed node groups?** AWS handles patching, scaling, and health checks