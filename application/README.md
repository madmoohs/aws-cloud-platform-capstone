# Application

## Online Boutique

This project uses [Google Online Boutique](https://github.com/GoogleCloudPlatform/microservices-demo), a cloud-native microservices demo application.

### Architecture

- **11 microservices** written in multiple languages (Go, Python, Node.js, Java, C#)
- **gRPC** for inter-service communication
- **RESTful API** for external access
- **Redis** for session management
- Demonstrates Kubernetes concepts: Deployments, Services, ConfigMaps, Secrets

### Services

| Service | Language | Description |
|---------|----------|-------------|
| frontend | Go | Exposes HTTP server to serve the website |
| cartservice | C# | Manages shopping cart in Redis |
| productcatalogservice | Go | Provides product details |
| currencyservice | Node.js | Converts currency |
| paymentservice | Node.js | Processes payments |
| shippingservice | Go | Calculates shipping costs |
| emailservice | Python | Sends confirmation emails |
| checkoutservice | Go | Orchestrates checkout process |
| recommendationservice | Python | Recommends products |
| adservice | Java | Serves context-based ads |

### Deployment

The application is deployed via Helm using the official Google OCI chart:

```bash
helm dependency update helm/
helm install online-boutique helm/ -f helm/values-dev.yaml --namespace online-boutique --create-namespace