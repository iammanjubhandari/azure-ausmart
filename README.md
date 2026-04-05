# devops-aks-ausmart — Production-Grade Retail Store on Azure AKS

Azure AKS implementation of a retail store microservices platform. 5 services, Kubernetes manifests, Helm charts, ArgoCD GitOps — all on Azure. Demonstrates production-grade infrastructure with Terraform modules/envs pattern.

## Architecture

```
User → Azure DNS → Azure WAF → Azure Load Balancer (NGINX Ingress)
                                        |
                                   Azure AKS
                                        |
                  +-------+-------+-------+-------+
                  |       |       |       |       |
                  UI   Catalog   Cart  Checkout  Orders
                  |       |       |       |       |
                  +-------+-------+-------+-------+
                                  |
                         Azure Data Plane
              (Azure DB for MySQL/PG, Redis, Service Bus)
```

## Tech Stack

- **Infrastructure**: Terraform, Azure VNet, AKS, Key Vault
- **Orchestration**: Azure Kubernetes Service, Helm
- **GitOps**: ArgoCD
- **Observability**: OpenTelemetry, Azure Monitor, Application Insights
- **CI/CD**: GitHub Actions (OIDC → Azure AD)
- **Security**: Azure WAF, Key Vault CSI, Workload Identity, NetworkPolicies, NSGs

## Author

**Manjunath Bhandari**

- [LinkedIn](https://www.linkedin.com/in/manjunathbhandari)
- [GitHub](https://github.com/iammanjubhandari)
