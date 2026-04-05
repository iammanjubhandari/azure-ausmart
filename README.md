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

## AWS → Azure Service Mapping

| AWS Service | Azure Service | What Changed |
|-------------|--------------|-------------|
| EKS | **AKS** | Built-in cluster autoscaler, Key Vault CSI, Workload Identity |
| VPC | **VNet** | NSGs instead of Security Groups |
| ALB + LBC | **Azure LB + NGINX Ingress** | NGINX replaces AWS LBC |
| Route53 | **Azure DNS** | Same ExternalDNS, different provider |
| AWS WAF | **Azure WAF** | OWASP 3.2 managed rules |
| RDS MySQL/PG | **Azure DB Flexible Server** | Subnet delegation + Private DNS Zone |
| DynamoDB | **DynamoDB Local** (in-cluster) | No managed equivalent provisioned |
| ElastiCache Redis | **Azure Cache for Redis** | SSL on port 6380 (not 6379) |
| ECR | **ACR** | Alphanumeric names only |
| Secrets Manager + CSI | **Key Vault + CSI** | Built-in AKS add-on |
| KMS | **Key Vault (keys)** | Keys + secrets + certs combined |
| Pod Identity | **Workload Identity** | Azure AD federated credentials |
| Karpenter | **AKS Cluster Autoscaler** | Built-in, no separate install |
| CloudWatch | **Azure Monitor + Log Analytics** | |
| X-Ray | **Application Insights** | |
| S3 (state) | **Storage Account (blob)** | |

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
