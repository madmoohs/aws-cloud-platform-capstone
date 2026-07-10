# Terraform Infrastructure

This directory provisions all AWS infrastructure required by the project.

## Modules

- Networking
- IAM
- Amazon EKS

Terraform provisions AWS resources only.

Kubernetes resources are managed separately using Kubernetes manifests, Helm, and ArgoCD.

## Environments

- Development
- Staging
- Production

Each environment consumes the same reusable Terraform modules.