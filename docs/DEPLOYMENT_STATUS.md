# Deployment Status

## Current Deployment (2026-07-11)

### Infrastructure
- **EKS Cluster**: `capstone` (ap-southeast-1)
- **Nodes**: 2 x t3.medium (Ready)
- **Terraform Backend**: S3 bucket + DynamoDB table (pre-existing)
- **Terraform Module Fix**: Updated `terraform/modules/cluster/main.tf` for compatibility with `terraform-aws-modules/eks` v21

### Deployed Applications

| Namespace | Application | Status | Replicas |
|-----------|-------------|--------|----------|
| online-boutique | Online Boutique microservices | Running | 12 pods |
| argocd | ArgoCD GitOps | Running | 6 pods |
| monitoring | Prometheus + Grafana + Loki | Running | 11 pods |
| ingress-nginx | nginx Ingress Controller | Running | 2 pods |
| kube-system | EKS Addons (VPC CNI, CoreDNS, kube-proxy) | Running | 4 pods |

### Access URLs

| Service | Status |
|---------|-----|
| Online Boutique | Success |
| ArgoCD UI | Success |
| Grafana | Success |

### CI/CD Pipeline Status

Latest GitHub Actions run: **SUCCESS** ✅

Jobs completed:
- TFLint: ✅
- Checkov (IaC Security): ✅
- Trivy Filesystem: ✅
- Snyk Security: ✅
- Helm Lint: ✅
- YAML Validation: ✅
- Terraform Validate: ✅
- Docker Build Validate: ✅

### Deployment Commands Used

```bash
# 1. Configure kubectl for existing cluster
aws eks update-kubeconfig --name capstone --region ap-southeast-1

# 2. Install ingress-nginx controller
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  --set controller.service.type=LoadBalancer

# 3. Deploy Online Boutique application
kubectl create namespace online-boutique
curl -L -o boutique.yaml https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml
sed 's/namespace: default/namespace: online-boutique/g' boutique.yaml | kubectl apply -n online-boutique -f -

# 4. Create ingress for frontend
kubectl apply -f ingress.yaml

# 5. Install ArgoCD
helm install argo-cd argo/argo-cd --namespace argocd --create-namespace \
  --set server.service.type=LoadBalancer

# 6. Install monitoring stack
helm install prometheus prometheus-community/prometheus \
  --namespace monitoring --create-namespace \
  --set server.service.type=ClusterIP \
  --set server.persistentVolume.enabled=false

helm install grafana grafana/grafana --namespace monitoring \
  --set adminPassword=admin --set service.type=LoadBalancer

helm install loki grafana/loki-distributed --namespace monitoring
helm install promtail grafana/promtail --namespace monitoring
```

### Notes

1. The Terraform state backend was pre-existing, so we used the existing `capstone` EKS cluster
2. VPC CNI addon was installed manually to bring nodes to Ready state
3. ArgoCD was installed via Helm instead of kubectl manifest for better management
4. Loki distributed requires object storage - installed without persistence for demo
