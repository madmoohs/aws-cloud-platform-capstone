# Project Showcase Guide

This guide walks you through deploying and showcasing your AWS Cloud Platform Capstone project.

## Prerequisites

Ensure you have the following installed and configured:
- AWS CLI with credentials configured (`aws configure`)
- Terraform >= 1.7.0
- kubectl
- Helm >= 3.14.0
- Docker
- Git

## Step-by-Step Showcase

### Step 1: Bootstrap Terraform Backend (First Time Only)

The bootstrap step creates an S3 bucket and DynamoDB table for Terraform state management.

```bash
./scripts/bootstrap.sh
```

This will:
- Create S3 bucket for Terraform state
- Create DynamoDB table for state locking
- Output the bucket and table names

**Expected Output:**
```
========================================
Bootstrap Complete!
  S3 Bucket:      <bucket-name>
  DynamoDB Table: <table-name>
========================================
```

### Step 2: Provision EKS Infrastructure

Deploy the AWS infrastructure using Terraform.

```bash
cd terraform/live/dev
terraform init
terraform plan
terraform apply
```

**Expected Output:**
- VPC with public and private subnets
- EKS cluster with node groups
- ALB Ingress Controller
- IAM roles and policies

**Time:** ~15-20 minutes

### Step 3: Configure kubectl

Connect kubectl to your newly created EKS cluster.

```bash
aws eks update-kubeconfig --region ap-southeast-1 --name aws-cloud-platform-capstone-dev
```

Verify connectivity:
```bash
kubectl get nodes
kubectl get namespaces
```

**Expected Output:**
```
NAME                                           STATUS   ROLES    AGE   VERSION
xxxxx.xx.xx.xx.xx.amazonaws.com   Ready    <none>   5m    v1.xx.x
```

### Step 4: Deploy the Application

Deploy the Online Boutique application using Helm.

```bash
cd /home/muhsin/aws-cloud-platform-capstone
helm dependency update helm/
helm install online-boutique helm/ -f helm/values-dev.yaml --namespace online-boutique --create-namespace
```

Verify deployment:
```bash
kubectl get pods -n online-boutique
kubectl get svc -n online-boutique
```

**Expected Output:** 10-11 pods running
- frontend
- cartservice
- productcatalogservice
- recommendationservice
- shippingservice
- checkoutservice
- paymentservice
- currencyservice
- emailservice
- adservice
- redis-cart

### Step 5: Install ArgoCD

ArgoCD provides GitOps-based continuous deployment.

```bash
# Create namespace
kubectl create namespace argocd

# Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for ArgoCD pods to be ready
kubectl wait --for=condition=ready pod --all -n argocd --timeout=300s
```

**Expected Output:**
```
pod/argocd-server-xxx Ready
pod/argocd-application-controller-xxx Ready
...
```

### Step 6: Access ArgoCD UI

Port-forward to access ArgoCD locally:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Access at: **https://localhost:8080**

**Default Credentials:**
- Username: `admin`
- Password: Get from cluster:
  ```bash
  kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode
  ```

**What to Show:**
1. **Applications** - You'll see 3 applications:
   - `online-boutique-dev` (synced to develop branch)
   - `online-boutique-staging` (synced to main branch)
   - `online-boutique-prod` (synced to main branch)

2. **Sync Status** - All should show "Synced" and "Healthy"

3. **Deployment History** - Show automated sync policy (self-heal, prune)

### Step 7: Deploy GitOps Applications

Apply the ArgoCD Application manifests:

```bash
kubectl apply -f gitops/dev.yaml
kubectl apply -f gitops/staging.yaml
kubectl apply -f gitops/prod.yaml
```

Verify in ArgoCD UI:
```bash
# Applications should auto-sync within a few minutes
kubectl get applications -n argocd
```

### Step 8: Install Monitoring Stack

Deploy Prometheus, Grafana, Loki, and Promtail for comprehensive observability.

```bash
# Add Helm repositories
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Install Prometheus
helm install prometheus prometheus-community/prometheus \
  -f monitoring/prometheus/prometheus-values.yaml \
  --namespace monitoring --create-namespace

# Install Grafana
helm install grafana prometheus-community/grafana \
  -f monitoring/grafana/grafana-values.yaml \
  --namespace monitoring

# Install Loki
helm install loki grafana/loki \
  -f monitoring/loki/loki-values.yaml \
  --namespace monitoring

# Install Promtail
helm install promtail grafana/promtail \
  -f monitoring/promtail/promtail-values.yaml \
  --namespace monitoring

# Wait for all monitoring pods to be ready
kubectl wait --for=condition=ready pod --all -n monitoring --timeout=300s
```

**Expected Output:**
```
NAME                     READY   STATUS    RESTARTS   AGE
prometheus-server-xxx    2/2     Running   0          5m
grafana-xxx             1/1     Running   0          5m
loki-xxx                1/1     Running   0          5m
promtail-xxx            1/1     Running   0          5m
```

### Step 9: Access Grafana Dashboard

Port-forward to Grafana:

```bash
kubectl port-forward -n monitoring svc/grafana 3000:80
```

Access at: **http://localhost:3000**

**Default Credentials:**
- Username: `admin`
- Password: `prom-operator`

**What to Show:**
1. **Home Dashboard** - Overview of all systems
2. **Kubernetes Cluster** (ID: 1621) - Cluster-wide metrics
3. **Kubernetes Nodes** (ID: 16098) - Per-node CPU/memory/network
4. **Kubernetes Pods** (ID: 15772) - Per-pod metrics

Navigate to Dashboards → Browse → Search for "Kubernetes"

### Step 10: Access the Application

Get the ALB Ingress URL:

```bash
# Get the ingress controller service
kubectl get svc -n ingress-nginx

# Or get the ALB hostname from the ingress
kubectl get ingress -n online-boutique
```

**Access the application at the EXTERNAL-IP hostname**

**What to Show:**
1. **Frontend** - Browse products, add to cart
2. **Product Catalog** - View available products
3. **Cart** - Add/remove items
4. **Checkout** - Complete a test order

### Step 11: Demonstrate GitOps Workflow

Show the complete GitOps workflow:

1. **Make a change** in your local environment:
   ```bash
   # Edit a value in helm/values-dev.yaml
   # For example, change the replica count
   ```

2. **Commit and push** to GitHub:
   ```bash
   git add helm/values-dev.yaml
   git commit -m "Update replica count for demo"
   git push origin develop
   ```

3. **Watch ArgoCD auto-sync**:
   - Open ArgoCD UI (http://localhost:8080)
   - Watch the `online-boutique-dev` application show "Syncing..."
   - Within 2-3 minutes, it will sync and show "Synced" + "Healthy"

4. **Verify the change**:
   ```bash
   kubectl get deployment -n online-boutique
   kubectl get pods -n online-boutique
   ```

5. **Check monitoring**:
   - Open Grafana (http://localhost:3000)
   - Go to Kubernetes Pods dashboard
   - See the updated pod count and resource usage

### Step 12: Show Infrastructure in AWS Console

Navigate to AWS Console to showcase the infrastructure:

1. **VPC** - Show the 3-tier architecture:
   - Public subnets (for ALB, NAT Gateway)
   - Private subnets (for EKS nodes, pods)

2. **EKS** - Show:
   - Cluster configuration
   - Node groups
   - Kubernetes workloads (view in "Resources" tab)

3. **EC2** - Show EKS node instances:
   - Auto Scaling Groups
   - Instance types (t3.medium, etc.)

4. **ALB** - Show:
   - Application Load Balancer
   - Target Groups
   - Listeners (HTTP/HTTPS)

5. **IAM** - Show:
   - EKS service role
   - Node instance role
   - ALB controller role

6. **S3** - Show Terraform state bucket

7. **DynamoDB** - Show Terraform lock table

### Step 13: Demonstrate Security Scanning (CI/CD)

Show the GitHub Actions pipeline:

1. Navigate to your repository on GitHub
2. Go to "Actions" tab
3. Show a recent workflow run
4. Highlight the security scanning stages:
   - **TFLint** - Terraform linting
   - **Checkov** - Infrastructure security
   - **Trivy** - Container vulnerability scanning
   - **Snyk** - Dependency scanning
   - **Helm Lint** - Chart validation

## Key Talking Points

### Architecture Highlights
- **Multi-Environment**: dev, staging, prod with separate Terraform workspaces
- **GitOps**: ArgoCD for declarative, automated deployments
- **Infrastructure as Code**: 100% Terraform, no manual AWS console changes
- **Security by Design**: DevSecOps pipeline scans everything
- **Observability**: Full-stack monitoring with metrics, logs, and dashboards

### Interview Story
1. **Challenge**: Build a production-style AWS platform from scratch
2. **Solution**: 
   - Used Terraform for immutable infrastructure
   - EKS for managed Kubernetes
   - ArgoCD for GitOps workflow
   - Helm for packaging multi-environment configs
   - GitHub Actions for CI/CD with security gates
3. **Results**:
   - Zero-downtime deployments via rolling updates
   - Automated rollback via ArgoCD self-heal
   - Full visibility via Prometheus + Grafana
   - Security-first approach with automated scanning

### Best Practices Demonstrated
- ✅ Infrastructure as Code (Terraform modules)
- ✅ GitOps workflow (ArgoCD)
- ✅ Progressive delivery (dev → staging → prod)
- ✅ Automated compliance (TFLint, Checkov, Trivy, Snyk)
- ✅ Observability (Prometheus, Grafana, Loki)
- ✅ Multi-environment isolation
- ✅ Least privilege IAM
- ✅ Private subnets for workloads
- ✅ ALB for ingress with SSL termination

## Quick Reference Commands

```bash
# Check cluster status
kubectl get nodes
kubectl get pods -A
kubectl get applications -n argocd

# Check ArgoCD logs
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-application-controller

# Check monitoring
kubectl get pods -n monitoring

# View application logs
kubectl logs -n online-boutique -l app=frontend --tail=100

# Restart a deployment
kubectl rollout restart deployment -n online-boutique frontend

# Port-forward for local access
kubectl port-forward -n argocd svc/argocd-server 8080:443  # ArgoCD UI
kubectl port-forward -n monitoring svc/grafana 3000:80      # Grafana UI

# Get ArgoCD admin password
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode
```

## Troubleshooting

### Pods not starting?
```bash
# Check pod status
kubectl get pods -n online-boutique

# Describe pod for events
kubectl describe pod <pod-name> -n online-boutique

# Check events
kubectl get events -n online-boutique --sort-by='.lastTimestamp'
```

### Can't access ArgoCD UI?
```bash
# Verify ArgoCD is running
kubectl get pods -n argocd

# Check service
kubectl get svc -n argocd

# Re-create port-forward
kubectl port-forward svc/argocd-server -n argocd 8080:443 --address='0.0.0.0'
```

### Can't access Grafana?
```bash
kubectl get pods -n monitoring
kubectl get svc -n monitoring
kubectl port-forward -n monitoring svc/grafana 3000:80
```

### Monitoring not showing data?
```bash
# Check Prometheus targets
kubectl port-forward -n monitoring svc/prometheus-server 9090:80
# Navigate to http://localhost:9090/targets

# Check Loki
kubectl get pods -n monitoring -l app=loki

# Check Promtail
kubectl get pods -n monitoring -l app=promtail
```

## Cleanup (When Done)

When you're done showcasing and want to clean up:

```bash
./scripts/cleanup.sh
```

This will destroy:
- EKS cluster and all resources
- Load balancers
- VPC components
- Bootstrap resources (S3, DynamoDB)

**WARNING:** This is irreversible! All data will be lost.

## Estimated Costs

For the dev environment (after showcasing):
- **EKS Cluster**: ~$73/month (control plane)
- **EKS Nodes**: ~$30/month (1x t3.medium)
- **ALB**: ~$25/month
- **NAT Gateway**: ~$45/month
- **Monitoring**: ~$20/month
- **Total**: ~$193/month

**Pro Tip:** Always run cleanup when done to avoid charges!

## Summary Checklist

- [ ] Bootstrap Terraform backend
- [ ] Provision EKS infrastructure
- [ ] Configure kubectl
- [ ] Deploy Online Boutique application
- [ ] Install ArgoCD
- [ ] Access ArgoCD UI
- [ ] Deploy GitOps applications
- [ ] Install monitoring stack
- [ ] Access Grafana dashboards
- [ ] Access application UI
- [ ] Demonstrate GitOps workflow (make a change, push, watch auto-sync)
- [ ] Show AWS Console infrastructure
- [ ] Show GitHub Actions pipeline
- [ ] Share interview talking points
- [ ] Cleanup when done

This completes the full project showcase!