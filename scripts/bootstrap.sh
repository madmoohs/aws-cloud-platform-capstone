#!/usr/bin/env bash
set -euo pipefail

####################################################
# Bootstrap Script
# Provisions S3 backend and DynamoDB lock table
####################################################

echo "========================================"
echo "AWS Cloud Platform Capstone - Bootstrap"
echo "========================================"

# Check prerequisites
command -v terraform >/dev/null 2>&1 || { echo "Error: terraform is required but not installed."; exit 1; }
command -v aws >/dev/null 2>&1 || { echo "Error: aws CLI is required but not installed."; exit 1; }

echo ""
echo "==> Initializing bootstrap Terraform..."
cd "$(dirname "$0")/../terraform/bootstrap"

terraform init

echo ""
echo "==> Applying bootstrap infrastructure..."
terraform apply -auto-approve

BUCKET=$(terraform output -raw terraform_state_bucket)
TABLE=$(terraform output -raw terraform_lock_table)

echo ""
echo "========================================"
echo "Bootstrap Complete!"
echo "  S3 Bucket:      ${BUCKET}"
echo "  DynamoDB Table: ${TABLE}"
echo "========================================"
echo ""
echo "Next steps:"
echo "  1. cd terraform/live/dev"
echo "  2. terraform init"
echo "  3. terraform plan"
echo "  4. terraform apply"
echo ""