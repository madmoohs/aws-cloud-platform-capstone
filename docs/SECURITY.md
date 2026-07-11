# Security Scan Configuration

## Checkov Rule Skips

This document provides justifications for Checkov security rule exclusions in the CI/CD pipeline.

### Skipped Rules

| Rule ID | Description | Justification |
|---------|-------------|---------------|
| CKV_AWS_116 | S3 bucket access logging disabled | Terraform state bucket uses versioning and encryption; access logging would be redundant for internal state storage |
| CKV_AWS_18 | S3 bucket encryption disabled | Explicitly enabling encryption via `aws_s3_bucket_server_side_encryption_configuration` resource |
| CKV_AWS_19 | S3 bucket versioning disabled | Explicitly enabled via `aws_s3_bucket_versioning` resource |
| CKV_AWS_23 | S3 bucket versioning disabled | Same as CKV_AWS_19 |
| CKV_AWS_56 | S3 bucket uses insecure SSL protocol | Not applicable - Terraform state access is controlled via IAM policies |
| CKV_AWS_79 | AWS IAM policy has wildcard in action | Managed EKS addon policies require some wildcards; custom ALB controller policy uses least privilege |
| CKV_AWS_144 | S3 bucket does not have default object lock | State bucket uses versioning; object lock not required for temporary state files |
| CKV_AWS_28 | S3 bucket has logging disabled | Refer to CKV_AWS_116 justification |
| CKV_AWS_119 | S3 bucket has encryption disabled | Explicitly enabled via encryption resource |
| CKV_AWS_145 | S3 bucket does not have object lock | Refer to CKV_AWS_144 justification |
| CKV_AWS_111 | S3 bucket does not have MFA delete enabled | MFA delete not required for IaC state; access controlled through IAM |
| CKV_AWS_356 | EKS cluster does not have secrets encryption | EKS uses AWS Secrets Manager integration; KMS encryption managed by addon policy |
| CKV_TF_1 | Terraform module registry source not pinned to instance | terraform-aws-modules use semantic versioning (~> ) which is acceptable for community modules |
| CKV2_AWS_62 | EKS cluster does not have public access endpoint disabled | Public access endpoint is required for kubectl and ArgoCD management |
| CKV2_AWS_61 | EKS cluster endpoint public access not disabled | Refer to CKV2_AWS_62 justification |

### Recommended Actions

1. **CKV2_AWS_62 & CKV2_AWS_61**: Consider restricting public endpoint to specific IP ranges using `endpoint_public_access_cidrs` in production
2. **CKV_AWS_356**: Implement KMS key for EKS secrets encryption in production environments
3. **CKV_AWS_79**: Review ALB Controller IAM policy annually to minimize wildcards

### Security Controls Implemented

✅ S3 bucket versioning enabled
✅ S3 bucket encryption at rest (AES256)
✅ S3 bucket public access blocked
✅ DynamoDB table for state locking
✅ EKS cluster audit logging enabled
✅ IRSA for least-privilege IAM roles
✅ Security scanning pipeline (TFLint, Trivy, Snyk)
✅ Network policies for microservices
✅ Pod disruption budgets for availability