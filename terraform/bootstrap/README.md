# Terraform Bootstrap

This directory provisions the Terraform remote backend.

Resources created:

- S3 Bucket
- DynamoDB Lock Table

Run only once before provisioning the platform.

## Commands

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

After the backend has been created, all other Terraform code under `terraform/live/` will use this remote backend.