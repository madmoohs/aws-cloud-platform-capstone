# Kubernetes

Kubernetes manifests for cluster-wide resources.

## Structure

```
kubernetes/
├── namespaces/     # Namespace definitions
├── ingress/        # ALB Ingress configuration
├── rbac/           # RBAC roles and bindings
└── storage/        # StorageClass definitions
```

## Resources

### Namespaces
- `online-boutique` - Application namespace
- `monitoring` - Prometheus, Grafana, Loki, Promtail
- `argocd` - ArgoCD GitOps operator

### Ingress
- ALB Ingress Controller configuration for the frontend service
- Internet-facing ALB with HTTP listener

### RBAC
- ClusterRole for read-only access to pods, services, deployments, ingresses
- ClusterRoleBinding for the online-boutique namespace

### Storage
- gp3 StorageClass with encryption enabled
- WaitForFirstConsumer binding mode

## Deployment

```bash
kubectl apply -f kubernetes/namespaces/
kubectl apply -f kubernetes/storage/
kubectl apply -f kubernetes/rbac/
kubectl apply -f kubernetes/ingress/
```

## Interview Talking Points

- **Why separate namespaces?** Isolation between application, monitoring, and GitOps
- **Why ALB Ingress?** AWS-native load balancing with path-based routing and SSL termination
- **Why RBAC?** Principle of least privilege - pods only get the permissions they need
- **Why gp3 StorageClass?** Cost-effective, encrypted, supports volume expansion