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

## What's Identical (Cloud-Agnostic)

- Kubernetes manifests (Deployments, Services, ConfigMaps)
- Helm charts and templates
- HPA autoscaling configs
- NetworkPolicies (default-deny + per-service allow)
- ArgoCD Application CRDs and sync policies
- Docker images and Dockerfile
- Git workflow (issue → branch → PR → merge)

## Project Structure

```
azure-ausmart/
  bootstrap/           # State backend (Storage Account + container)
  modules/             # Terraform modules (VNet, AKS, Key Vault, DB, Redis, ACR, WAF, NSG, Monitoring)
  envs/                # Per-environment configs (au-dev, au-prod, us-prod)
  kubernetes/          # K8s manifests (5 services + ingress + network policies)
  helm/                # Helm charts + per-env values
  cicd/                # GitHub Actions + ArgoCD
  observability/       # OTEL → Azure Monitor + Application Insights
  autoscaling/         # HPA configs + KEDA
  diagrams/            # Architecture diagrams (mermaid + text)
```

## Quick Start

```bash
# 0. Bootstrap state backend (run once)
cd bootstrap/
terraform init && terraform apply

# 1. Provision infrastructure
cd ../envs/au-dev/
terraform init
terraform apply -var-file="terraform.tfvars"

# 2. Configure kubectl
az aks get-credentials --resource-group ausmart-dev-rg --name ausmart-aks

# 3. Deploy application
kubectl apply -f kubernetes/manifests/00-namespace/
kubectl apply -f kubernetes/manifests/01-secrets/
kubectl apply -f kubernetes/manifests/02-catalog/
kubectl apply -f kubernetes/manifests/03-cart/
kubectl apply -f kubernetes/manifests/04-checkout/
kubectl apply -f kubernetes/manifests/05-orders/
kubectl apply -f kubernetes/manifests/06-ui/
kubectl apply -f kubernetes/manifests/07-ingress/
```

## Tech Stack

- **Infrastructure**: Terraform, Azure VNet, AKS, Key Vault
- **Orchestration**: Azure Kubernetes Service, Helm
- **GitOps**: ArgoCD
- **Observability**: OpenTelemetry, Azure Monitor, Application Insights
- **CI/CD**: GitHub Actions (OIDC → Azure AD)
- **Security**: Azure WAF, Key Vault CSI, Workload Identity, NetworkPolicies, NSGs

## See Also

- [AWS EKS version](https://github.com/iammanjubhandari/devops-eks-ausmart) — same app, AWS services

## Author

**Manjunath Bhandari**

- [LinkedIn](https://www.linkedin.com/in/manjunathbhandari)
- [GitHub](https://github.com/iammanjubhandari)
