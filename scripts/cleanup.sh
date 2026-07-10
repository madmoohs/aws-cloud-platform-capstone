#!/usr/bin/env bash
set -euo pipefail

####################################################
# Cleanup Script
# Destroys all infrastructure and bootstrap resources
####################################################

echo "========================================"
echo "AWS Cloud Platform Capstone - Cleanup"
echo "========================================"
echo "WARNING: This will destroy ALL infrastructure!"
echo ""

read -p "Are you sure you want to continue? (y/N) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cleanup cancelled."
    exit 1
fi

# Check prerequisites
command -v terraform >/dev/null 2>&1 || { echo "Error: terraform is required but not installed."; exit 1; }

echo ""
echo "==> Destroying dev environment..."
cd "$(dirname "$0")/../terraform/live/dev"
terraform init -reconfigure
terraform destroy -auto-approve

echo ""
echo "==> Destroying bootstrap resources..."
cd "$(dirname "$0")/../terraform/bootstrap"
terraform init -reconfigure
terraform destroy -auto-approve

echo ""
echo "========================================"
echo "Cleanup Complete!"
echo "All infrastructure has been destroyed."
echo "========================================"