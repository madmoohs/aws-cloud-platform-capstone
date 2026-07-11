# AWS Cloud Platform Capstone

A production-style AWS Cloud Platform demonstrating the complete lifecycle of modern Cloud/DevOps/SRE/DevSecOps engineering.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    GitHub Repository                         │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │ Terraform│  │  Helm    │  │Kubernetes│  │  GitOps  │   │
│  │   IaC    │  │  Charts  │  │ Manifests│  │ ArgoCD   │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│                    CI/CD Pipeline                            │
│  ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌────────┐ │
│  │TFLint│ │Checkov│ │Trivy │ │ Snyk │ │Helm  │ │Deploy  │ │
│  │      │ │      │ │      │ │      │ │ Lint │ │        │ │
│  └──────┘ └──────┘ └──────┘ └──────┘ └──────┘ └────────┘ │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│                    AWS Cloud Platform                        │
│  ┌──────────┐  ┌──────────┐  ┌──────────────────────────┐  │
│  │   VPC    │  │   EKS    │  │   Observability Stack    │  │
│  │  ┌────┐  │  │  ┌────┐  │  │  ┌────┐ ┌────┐ ┌────┐  │  │
│  │  │Public│  │  │ │Node│  │  │  │Prom │ │Graf│ │Loki│  │  │
│  │  │Subnet│  │  │ │Grp │  │  │  │etheus│ │ana │ │    │  │  │
│  │  └────┘  │  │  └────┘  │  │  └────┘ └────┘ └────┘  │  │
│  │  ┌────┐  │  │  ┌────┐  │  │  ┌──────┐               │  │
│  │  │Private│  │  │ │ALB │  │  │Promtail│              │  │
│  │  │Subnet │  │  │ │Ctrl│  │  └──────┘               │  │
│  │  └────┘  │  │  └────┘  │  └──────────────────────────┘  │
│  └──────────┘  └──────────┘                                 │
└─────────────────────────────────────────────────────────────┘
```

## Repository Structure

```
├── .github/workflows/   # CI/CD pipelines (TFLint, Checkov, Trivy, Snyk, Helm)
├── terraform/           # Infrastructure as Code (VPC, EKS, IAM, S3, DynamoDB)
├── helm/                # Helm chart for Online Boutique (3 environments)
├── kubernetes/          # Kubernetes manifests (namespaces, ingress, RBAC, storage)
├── gitops/              # ArgoCD Application manifests (dev/staging/prod)
├── monitoring/          # Observability stack (Prometheus, Grafana, Loki, Promtail)
├── application/         # Application reference
├── scripts/             # Bootstrap and cleanup scripts
└── docs/                # Architecture diagrams and documentation
```

## Prerequisites

- AWS Account with appropriate permissions
- Terraform >= 1.7.0
- AWS CLI configured
- kubectl
- Helm >= 3.14.0
- Docker

## Quick Start

### 1. Bootstrap Backend

```bash
cd terraform/bootstrap
terraform init
terraform apply
```

### 2. Provision Infrastructure

```bash
cd terraform/live/dev
terraform init
terraform plan
terraform apply
```

### 3. Configure kubectl

```bash
aws eks update-kubeconfig --region ap-southeast-1 --name aws-cloud-platform-capstone-dev
kubectl get nodes
```

### 4. Deploy Application

```bash
helm dependency update helm/
helm install online-boutique helm/ -f helm/values-dev.yaml --namespace online-boutique --create-namespace
```

### 5. Install Monitoring

```bash
# Prometheus
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/prometheus -f monitoring/prometheus/prometheus-values.yaml --namespace monitoring --create-namespace

# Grafana
helm install grafana prometheus-community/grafana -f monitoring/grafana/grafana-values.yaml --namespace monitoring

# Loki
helm repo add grafana https://grafana.github.io/helm-charts
helm install loki grafana/loki -f monitoring/loki/loki-values.yaml --namespace monitoring

# Promtail
helm install promtail grafana/promtail -f monitoring/promtail/promtail-values.yaml --namespace monitoring
```

### 6. Install ArgoCD

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### 7. Deploy GitOps Applications

```bash
kubectl apply -f gitops/dev.yaml
kubectl apply -f gitops/staging.yaml
kubectl apply -f gitops/prod.yaml
```

## Environments

| Environment | Cluster Name | Branch | Node Count |
|-------------|-------------|--------|------------|
| Development | aws-cloud-platform-capstone-dev | develop | 1-3 |
| Staging     | aws-cloud-platform-capstone-staging | main | 1-5 |
| Production  | aws-cloud-platform-capstone-prod | main | 2-10 |

## CI/CD Pipeline

```
Developer → Push → GitHub Actions → TFLint → Checkov → Trivy → Snyk → Docker Build → Helm Lint → Update Values → Commit → GitHub → ArgoCD → EKS
```

## Security (DevSecOps)

- **TFLint**: Terraform linting and best practices
- **Checkov**: Infrastructure security scanning
- **Trivy**: Filesystem and container vulnerability scanning
- **Snyk**: Dependency vulnerability scanning
- **Helm Lint**: Chart validation

## Monitoring (SRE)

- **Prometheus**: Metrics collection and alerting
- **Grafana**: Visualization with pre-configured dashboards
- **Loki**: Log aggregation
- **Promtail**: Log shipping from pods

## Key Features

- ✅ Infrastructure as Code (Terraform)
- ✅ Kubernetes (EKS)
- ✅ GitOps (ArgoCD)
- ✅ CI/CD (GitHub Actions)
- ✅ DevSecOps (Security scanning pipeline)
- ✅ Monitoring & Observability (Prometheus, Grafana, Loki)
- ✅ Multi-environment deployments (dev/staging/prod)
- ✅ Production repository organization
- ✅ Helm packaging
- ✅ ALB Ingress Controller (ingress-nginx)
- ✅ RBAC
- ✅ Storage classes

## Deployment Status

This project has been successfully deployed to AWS EKS. See [docs/DEPLOYMENT_STATUS.md](docs/DEPLOYMENT_STATUS.md) for current deployment details.

**GitHub Actions CI Status:** All jobs passing ✅ (TFLint, Checkov, Trivy, Snyk, Helm Lint, YAML Validation)
