# GitOps

ArgoCD Application manifests for GitOps deployment.

## Structure

```
gitops/
├── dev.yaml       # Development ArgoCD Application
├── staging.yaml   # Staging ArgoCD Application
└── prod.yaml      # Production ArgoCD Application
```

## How It Works

1. Developer pushes code to GitHub
2. GitHub Actions runs CI/CD pipeline
3. Pipeline updates Helm values and commits back to GitHub
4. ArgoCD detects the change in the repository
5. ArgoCD syncs the desired state to the EKS cluster

## Pipeline Flow

```
Developer → Push → GitHub Actions → Security Scans → Build → Update Helm Values → Commit → GitHub → ArgoCD → EKS
```

## ArgoCD Applications

| Environment | Branch | Helm Values | Cluster |
|-------------|--------|-------------|---------|
| Development | develop | values-dev.yaml | aws-cloud-platform-capstone-dev |
| Staging     | main    | values-staging.yaml | aws-cloud-platform-capstone-staging |
| Production  | main    | values-prod.yaml | aws-cloud-platform-capstone-prod |

## Installation

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

## Deploy Applications

```bash
kubectl apply -f gitops/dev.yaml
kubectl apply -f gitops/staging.yaml
kubectl apply -f gitops/prod.yaml
```

## Interview Talking Points

- **Why GitOps?** Single source of truth, automated drift detection, self-healing clusters
- **Why ArgoCD?** Kubernetes-native, supports Helm, multi-environment, declarative
- **Why not push-based?** Pull-based GitOps is more secure (cluster pulls from Git, no credentials in CI)
- **Why separate Applications?** Environment isolation with different sync policies and target revisions