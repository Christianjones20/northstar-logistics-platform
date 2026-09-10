# NorthStar Logistics Platform

NorthStar Logistics Platform is a cloud-native logistics and order management application designed to demonstrate secure application delivery, Azure infrastructure, Kubernetes orchestration, infrastructure as code, and DevSecOps automation.

The project was built as a hands-on cloud engineering and security portfolio project with an emphasis on reproducibility, secure identity, container security, CI/CD, and Azure-native services.

---

## Project Overview

NorthStar Logistics is a fictional logistics company that needed to modernize an order management platform that was previously deployed manually and lacked consistent security, automation, centralized monitoring, and resilient cloud infrastructure.

The goal of this project was to design and deploy a secure Azure-based application platform that:

- runs containerized frontend and backend workloads;
- uses Infrastructure as Code for repeatable infrastructure deployment;
- stores application data in a managed PostgreSQL database;
- manages secrets through Azure Key Vault;
- runs workloads on Azure Kubernetes Service;
- exposes the application through a Kubernetes Ingress;
- encrypts public traffic with HTTPS;
- uses GitHub Actions for CI/CD automation;
- scans container images for vulnerabilities;
- signs container images before deployment;
- uses workload identity and OIDC instead of long-lived credentials.

---

## Architecture

```text
                        Internet
                           |
                        HTTPS
                           |
                           v
                  Azure Load Balancer
                           |
                           v
                   NGINX Ingress
                     /          \
                    /            \
                   v              v
          Frontend Service    Backend Service
                 |                  |
                 v                  v
          React + Nginx          FastAPI
                                    |
                                    v
                         PostgreSQL Flexible Server
                          Private Azure Networking


                         FastAPI Backend
                                |
                                v
                       Azure Workload Identity
                                |
                                v
                         Azure Key Vault


                         GitHub Actions
                                |
                          GitHub OIDC
                                |
                                v
                              Azure
                                |
                    -------------------------
                    |                       |
                    v                       v
                   ACR                     AKS
                    |
                    v
             Signed Container Images
```

---

## Technology Stack

### Application

#### Frontend

- React
- Vite
- Nginx
- JavaScript
- HTML/CSS

#### Backend

- Python
- FastAPI
- SQLAlchemy
- Pydantic
- Uvicorn

#### Database

- Azure Database for PostgreSQL Flexible Server
- PostgreSQL

---

## Azure Infrastructure

- Azure Kubernetes Service
- Azure Container Registry
- Azure Virtual Network
- Azure Subnets
- Azure Network Security Groups
- Azure Database for PostgreSQL
- Azure Key Vault
- Azure Managed Identities
- Azure Workload Identity
- Azure Log Analytics
- Azure Load Balancer

---

## Infrastructure as Code

Infrastructure is provisioned and managed using Terraform.

The Terraform configuration is organized into reusable modules for:

- networking;
- Kubernetes and container infrastructure;
- databases;
- security;
- monitoring.

Example structure:

```text
infrastructure/
└── terraform/
    ├── environments/
    │   ├── dev/
    │   └── prod/
    │
    └── modules/
        ├── networking/
        ├── container-platform/
        ├── database/
        ├── security/
        └── monitoring/
```

Terraform manages resources such as:

- VNets and subnets;
- Network Security Groups;
- AKS;
- Azure Container Registry;
- PostgreSQL;
- Azure Key Vault;
- managed identities;
- federated identity credentials;
- Log Analytics.

---

## Kubernetes Architecture

The application runs on Azure Kubernetes Service.

The Kubernetes environment includes:

- Namespaces
- Deployments
- Services
- Ingress
- Service Accounts
- Secrets
- ConfigMaps
- Resource requests and limits
- Azure Workload Identity
- Secrets Store CSI Driver

The main namespace is:

```text
northstar
```

Frontend traffic is routed through:

```text
Internet
→ Azure Load Balancer
→ NGINX Ingress
→ northstar-frontend Service
→ Nginx container
```

Backend API traffic is routed through:

```text
Internet
→ Azure Load Balancer
→ NGINX Ingress
→ northstar-backend Service
→ FastAPI container
```

---

## HTTPS and TLS

The application is publicly accessible through HTTPS.

A temporary DNS hostname is provided using `nip.io`.

The application currently uses:

```text
https://northstar.172.168.110.106.nip.io
```

TLS certificates are automatically issued and managed using:

- cert-manager;
- Let's Encrypt;
- Kubernetes TLS Secrets.

The public request flow is:

```text
Browser
→ HTTPS 443
→ Azure Load Balancer
→ NGINX Ingress
→ Kubernetes Services
→ Application Pods
```

---

## Application API

The FastAPI backend exposes order-management endpoints.

Examples include:

```text
GET    /health
GET    /orders
GET    /orders/{id}
POST   /orders
PUT    /orders/{id}
DELETE /orders/{id}
```

Health check example:

```bash
curl https://northstar.172.168.110.106.nip.io/health
```

Expected response:

```json
{
  "status": "healthy"
}
```

---

## Security Controls

Security was incorporated throughout the platform rather than added only after deployment.

### Azure Key Vault

Database credentials and other sensitive values are stored in Azure Key Vault rather than directly inside Kubernetes deployment manifests.

The backend retrieves secrets through the Azure Secrets Store CSI Driver.

### Azure Workload Identity

The backend uses Azure Workload Identity to authenticate to Azure resources.

This avoids storing Azure credentials inside the application or Kubernetes Secrets.

The identity flow is:

```text
Kubernetes Service Account
        |
        v
Federated Identity Credential
        |
        v
Azure Managed Identity
        |
        v
Azure Key Vault
```

### Private Database Networking

Azure PostgreSQL is deployed using private networking.

The database is not intended to be directly exposed to the public internet.

Application traffic reaches PostgreSQL through the Azure virtual network.

### Network Security Groups

Network Security Groups restrict traffic between infrastructure components.

Ingress traffic is limited to the required application ports.

Azure Load Balancer health probes are allowed separately from general internet traffic.

### GitHub OIDC Authentication

GitHub Actions authenticates to Azure using OpenID Connect.

The pipeline does not require a stored Azure client secret.

Authentication flow:

```text
GitHub Actions
      |
      v
GitHub OIDC Token
      |
      v
Microsoft Entra ID
      |
      v
Azure Service Principal
```

---

## Container Security

### Trivy Vulnerability Scanning

Container images are scanned with Trivy before deployment.

The pipeline checks for HIGH and CRITICAL severity vulnerabilities.

If a configured security threshold is exceeded, the pipeline fails and prevents deployment.

### Container Image Signing

Container images are signed using Cosign and Sigstore.

The project uses keyless signing through GitHub OIDC instead of storing a long-lived signing key.

Pipeline flow:

```text
Docker Build
    |
    v
Push Image to ACR
    |
    v
Trivy Scan
    |
    v
Cosign Sign
    |
    v
Cosign Verify
    |
    v
Deploy to AKS
```

This provides additional software supply-chain assurance by proving that the container image was produced by the authorized GitHub Actions workflow.

---

## CI/CD Pipeline

GitHub Actions is used for automated application validation, security checks, image creation, and deployment.

The pipeline includes:

```text
Source Code
    |
    v
GitHub Actions
    |
    v
Backend Validation
    |
    v
Frontend Validation
    |
    v
Terraform Validation
    |
    v
Container Build
    |
    v
Push to Azure Container Registry
    |
    v
Trivy Vulnerability Scan
    |
    v
Cosign Image Signing
    |
    v
Cosign Signature Verification
    |
    v
Deployment Approval
    |
    v
AKS Deployment
    |
    v
Rollout Verification
    |
    v
HTTPS Health Check
```

Container images are tagged using the Git commit SHA.

Example:

```text
northstar-backend:<git-sha>
northstar-frontend:<git-sha>
```

Using commit-based image tags provides traceability between deployed containers and the source code that produced them.

---

## GitHub Actions Workflows

Example workflow structure:

```text
.github/
└── workflows/
    ├── ci.yml
    ├── build-images.yml
    └── deploy-aks.yml
```

### CI Workflow

The CI workflow validates:

- Python backend code;
- frontend linting;
- frontend builds;
- Terraform formatting;
- Terraform validation;
- repository security scanning.

### Build and Deploy Workflow

The deployment workflow performs:

- Azure authentication using OIDC;
- ACR authentication;
- backend image build;
- frontend image build;
- image push;
- Trivy image scanning;
- Cosign image signing;
- signature verification;
- AKS deployment;
- rollout verification;
- application health checks.

---

## Monitoring

Azure Log Analytics is used as the centralized monitoring workspace for the environment.

AKS monitoring data can be used to investigate:

- container health;
- pod failures;
- Kubernetes events;
- resource utilization;
- platform diagnostics.

---

## Repository Structure

```text
northstar-logistics-platform/
│
├── application/
│   ├── backend/
│   │   ├── main.py
│   │   ├── database.py
│   │   ├── Dockerfile
│   │   └── requirements.txt
│   │
│   └── frontend/
│       ├── src/
│       ├── Dockerfile
│       ├── package.json
│       └── vite.config.js
│
├── infrastructure/
│   └── terraform/
│       ├── environments/
│       │   ├── dev/
│       │   └── prod/
│       │
│       └── modules/
│           ├── networking/
│           ├── container-platform/
│           ├── database/
│           ├── security/
│           └── monitoring/
│
├── kubernetes/
│   ├── manifests/
│   │   └── dev/
│   └── ingress-nginx-values.yaml
│
├── .github/
│   └── workflows/
│
└── README.md
```

---

## Local Development

### Backend

Navigate to the backend:

```bash
cd application/backend
```

Create or activate the Python virtual environment:

```bash
source .venv/bin/activate
```

Start FastAPI:

```bash
uvicorn main:app --reload
```

### Frontend

Navigate to:

```bash
cd application/frontend
```

Install dependencies:

```bash
npm install
```

Run the Vite development server:

```bash
npm run dev
```

---

## Docker

The frontend and backend are containerized separately.

Backend example:

```bash
docker build -t northstar-backend application/backend
```

Frontend example:

```bash
docker build -t northstar-frontend application/frontend
```

For the cloud deployment, images are stored in Azure Container Registry.

---

## Infrastructure Deployment

Navigate to the development Terraform environment:

```bash
cd infrastructure/terraform/environments/dev
```

Initialize Terraform:

```bash
terraform init
```

Validate:

```bash
terraform validate
```

Review infrastructure changes:

```bash
terraform plan
```

Apply approved infrastructure changes:

```bash
terraform apply
```

Sensitive values should not be committed to source control.

---

## Security Practices Demonstrated

This project demonstrates practical experience with:

- Infrastructure as Code
- Azure security
- Kubernetes security
- container security
- vulnerability management
- software supply-chain security
- image signing
- CI/CD security gates
- GitHub Actions
- OpenID Connect
- workload identity
- managed identities
- secrets management
- private networking
- TLS encryption
- least privilege
- security automation

---

## Current Project Status

The development environment currently supports:

- Azure infrastructure provisioned with Terraform
- AKS application hosting
- React frontend
- FastAPI backend
- private PostgreSQL database
- Azure Key Vault integration
- Kubernetes workload identity
- NGINX Ingress
- public HTTPS access
- Let's Encrypt TLS certificates
- GitHub Actions CI/CD
- Trivy vulnerability scanning
- Cosign image signing and verification
- Git commit-based container image versioning
- automated deployment health checks

---

## Demo

A live Azure-hosted development environment is available periodically for demonstration purposes.

The environment may be stopped outside demonstration periods to control cloud costs.

Demo URL:

```text
https://northstar.172.168.110.106.nip.io
```

---

## Future Improvements

Potential future enhancements include:

- Helm packaging for all Kubernetes workloads;
- deployment by immutable container digest instead of image tag;
- Kubernetes admission policies requiring signed images;
- Azure Policy for AKS;
- Kubernetes NetworkPolicies;
- Horizontal Pod Autoscaling;
- Pod Disruption Budgets;
- Azure Monitor alerts;
- centralized dashboards;
- Web Application Firewall;
- custom DNS domain;
- production-grade PostgreSQL sizing;
- separate staging and production environments;
- stricter GitHub branch protection;
- required pull request reviews;
- SBOM generation and attestation;
- policy-as-code controls;
- automated rollback strategies.

---

## Disclaimer

NorthStar Logistics is a fictional organization created for educational and portfolio purposes.

The application and infrastructure are intended to demonstrate cloud engineering, DevOps, Kubernetes, and security concepts rather than serve as a production logistics platform.