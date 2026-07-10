# Scripts

Utility scripts for managing the AWS Cloud Platform.

## bootstrap.sh

Provisions the S3 backend bucket and DynamoDB lock table for Terraform state.

```bash
./scripts/bootstrap.sh
```

## cleanup.sh

Destroys all infrastructure and bootstrap resources.

```bash
./scripts/cleanup.sh
```

**Warning:** This will destroy ALL resources. Use with caution.