# Documentation

## Architecture Diagrams

### 1. AWS Infrastructure Architecture

`architecture.png` - Shows the complete AWS infrastructure:

```
Terraform → VPC → EKS → ALB → Online Boutique → Monitoring → ArgoCD
```

Key components:
- VPC with public/private subnets, IGW, NAT Gateway
- EKS Cluster with managed node groups
- ALB Ingress Controller for traffic routing
- Online Boutique microservices
- Prometheus, Grafana, Loki, Promtail for observability
- ArgoCD for GitOps deployment

### 2. CI/CD Pipeline

`pipeline.png` - Shows the end-to-end pipeline:

```
Developer → GitHub → GitHub Actions → Security Scans → Build → Helm → ArgoCD → EKS
```

Pipeline stages:
1. **Push**: Developer pushes code to GitHub
2. **CI**: GitHub Actions runs Terraform validation, TFLint, Checkov, Trivy, Snyk, Helm lint
3. **Build**: Docker image built and pushed to ECR
4. **Helm**: Values updated with new image tag, committed to Git
5. **GitOps**: ArgoCD detects change, syncs to EKS cluster
6. **Monitoring**: Prometheus/Grafana/Loki observe the deployment