# Practical DevOps on Azure Cloud-Base

<!-- ## Architecture Overview
This project implements a microservices architecture on Azure Kubernetes Service, consisting of three main services:
- Frontend Service
- Backend Service
- MongoDB Database -->

## Prerequisites
- Azure Subscription
- Azure CLI
- Terraform
- Helm
- kubectl
<!-- - Azure DevOps Account -->

## Infrastructure Setup

### 0. Create Azure Service Principal
```bash
az ad sp create-for-rbac --sdk-auth --role="Owner" --scopes="/subscriptions/xx-xxxx-" -n "practical-devops"
```

### 1. Azure Resources (Terraform)
```bash
# Move to terraform folder
cd terraform

# Login to Azure
az login

# Initialize Terraform
terraform init

# Validate Terraform
terraform validate

# Review the plan
terraform plan -var-file=terraform.tfvars -out=terraform.plan

# Apply the configuration
terraform apply terraform.plan
```

Key resources created:
- Azure Virtual Network
- Azure Container Registry (ACR)
- Azure Kubernetes Service (AKS)

### 2. CI/CD Pipeline (Azure DevOps)
Not start Yet
<!-- 
#### Setup Steps:
1. Create Azure DevOps Project
2. Configure Service Connections
3. Create Variable Groups for environments
4. Import pipeline definitions

#### Pipeline Structure:
```
└── repository root
    ├── azure-pipelines.yml
    ├── frontend/
    │   ├── azure-pipelines.yml
    │   ├── Dockerfile
    │   └── k8s/
    │       └── deployment.yaml
    ├── backend/
    │   ├── azure-pipelines.yml
    │   ├── Dockerfile
    │   └── k8s/
    │       └── deployment.yaml
    └── mongodb/
        ├── azure-pipelines.yml
        ├── Dockerfile
        └── k8s/
            └── deployment.yaml
``` -->

### 3. Monitoring Setup (Prometheus & Grafana)

#### Install Monitoring Stack:
```bash
# Add Helm repositories
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Run in Git Bash
helm pull prometheus-community/kube-prometheus-stack --version 48.1.1
tar -xzf kube-prometheus-stack-48.1.1.tgz
cp kube-prometheus-stack/values.yaml ./kube-prometheus-stack-values.yaml

# Install Prometheus
helm -n monitoring upgrade prometheus-grafana-stack --create-namespace --install -f kube-prometheus-stack-values.yaml kube-prometheus-stack

# Update configuration
helm -n monitoring upgrade prometheus-grafana-stack --create-namespace -f kube-prometheus-stack-values.yaml kube-prometheus-stack
```

#### Access Grafana:
```bash

# Port forward Prometheus service
kubectl port-forward -n monitoring svc/prometheus-operated 9090:9090

# Port forward Grafana service
kubectl port-forward -n monitoring svc/prometheus-grafana-stack 80:80
```

Default login:
- Username: admin
- Password: prom-operator