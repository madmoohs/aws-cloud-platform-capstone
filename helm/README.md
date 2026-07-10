# Helm

This directory contains the Helm deployment for Online Boutique.

Environment-specific values are separated into:

- values-dev.yaml
- values-staging.yaml
- values-prod.yaml

ArgoCD deploys this chart.

GitHub Actions updates the image tag inside the corresponding values file.

Helm retrieves the official Online Boutique chart from Google's OCI registry, ensuring the application manifests remain up to date while keeping this repository lightweight.