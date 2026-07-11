#!/usr/bin/env bash
set -euo pipefail

####################################################
# Cleanup Script
# Destroys Terraform environments and bootstrap resources
####################################################

echo "========================================"
echo "AWS Cloud Platform Capstone - Cleanup"
echo "========================================"

# Parse arguments
ENVIRONMENT="${1:-all}"

VALID_ENVIRONMENTS=("dev" "staging" "prod" "all")
if [[ ! " ${VALID_ENVIRONMENTS[@]} " =~ " ${ENVIRONMENT} " ]]; then
    echo "Error: Invalid environment '${ENVIRONMENT}'"
    echo "Usage: $0 [dev|staging|prod|all]"
    echo "  dev      - Destroy dev environment only"
    echo "  staging  - Destroy staging environment only"
    echo "  prod     - Destroy production environment only"
    echo "  all      - Destroy all environments and bootstrap (default)"
    exit 1
fi

echo ""
echo "Target environments: ${ENVIRONMENT}"
echo ""
echo "WARNING: This will DESTROY infrastructure!"
echo ""

read -p "Are you sure you want to continue? (y/N) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cleanup cancelled."
    exit 1
fi

# Check prerequisites
command -v terraform >/dev/null 2>&1 || { echo "Error: terraform is required but not installed."; exit 1; }

# Destroy specified environment(s)
case "${ENVIRONMENT}" in
    "all")
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
        ;;
    "dev"|"staging"|"prod")
        echo ""
        echo "==> Destroying ${ENVIRONMENT} environment..."
        cd "$(dirname "$0")/../terraform/live/${ENVIRONMENT}"
        terraform init -reconfigure
        terraform destroy -auto-approve
        ;;
esac

echo ""
echo "========================================"
echo "Cleanup Complete!"
echo "Environment(s) '${ENVIRONMENT}' have been destroyed."
echo "========================================"
