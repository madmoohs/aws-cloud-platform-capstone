# Monitoring

Complete observability stack for the AWS Cloud Platform.

## Stack

| Component | Purpose | Installation |
|-----------|---------|-------------|
| Prometheus | Metrics collection and alerting | prometheus-community/prometheus |
| Grafana | Metrics and log visualization | prometheus-community/grafana |
| Loki | Log aggregation | grafana/loki |
| Promtail | Log shipping from pods | grafana/promtail |

## Architecture

```
Pods → Promtail → Loki → Grafana
Pods → Prometheus → Grafana
```

## Installation

```bash
# Prometheus
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/prometheus \
  -f monitoring/prometheus/prometheus-values.yaml \
  --namespace monitoring --create-namespace

# Grafana
helm install grafana prometheus-community/grafana \
  -f monitoring/grafana/grafana-values.yaml \
  --namespace monitoring

# Loki
helm repo add grafana https://grafana.github.io/helm-charts
helm install loki grafana/loki \
  -f monitoring/loki/loki-values.yaml \
  --namespace monitoring

# Promtail
helm install promtail grafana/promtail \
  -f monitoring/promtail/promtail-values.yaml \
  --namespace monitoring
```

## Grafana Access

```bash
kubectl port-forward -n monitoring svc/grafana 3000:80
```

Default credentials: `admin` / `prom-operator`

## Pre-configured Dashboards

- **Kubernetes Cluster** (ID: 1621) - Cluster-wide resource usage
- **Kubernetes Nodes** (ID: 16098) - Per-node CPU, memory, network
- **Kubernetes Pods** (ID: 15772) - Per-pod metrics

## Interview Talking Points

- **Why Prometheus?** Industry standard for Kubernetes monitoring, pull-based metrics
- **Why Grafana?** Rich dashboarding, multi-data source support (Prometheus + Loki)
- **Why Loki?** Log aggregation designed for Kubernetes, cost-effective (no indexing)
- **Why Promtail?** Kubernetes-native log shipping, pod metadata enrichment
- **Why this stack?** Covers metrics, logs, and visualization - the three pillars of observability