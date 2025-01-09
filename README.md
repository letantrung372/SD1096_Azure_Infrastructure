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
#### Setup Steps:
1. Create Azure DevOps Project
2. Configure Service Connections
3. Import pipeline definitions

#### Configure Service Connections  

**1. ACR Service Connection**  
This service connection allows Azure DevOps to push and pull images from the Azure Container Registry.  

**Steps to Configure:**  
Navigate to **Project Settings** > **Service connections** in Azure DevOps. Create a new service connection of type **Azure Resource Manager**, select the subscription containing the ACR, and choose the resource group where the ACR is located. Finally, grant permissions to pipelines to use this connection.  

**2. AKS Service Connection**  
This service connection allows Azure DevOps to interact with the AKS cluster for deployment.  

**Steps to Configure:**  
Go to **Project Settings** > **Service connections** in Azure DevOps. Create a new service connection of type **Kubernetes**, provide the cluster name, namespace, and credentials, and grant pipeline permissions to use the connection.  

**3. ARM Service Connection**  
This service connection allows interaction with Azure Resource Manager (ARM) for managing resources.  

**Steps to Configure:**  
Navigate to **Project Settings** > **Service connections** in Azure DevOps. Create a new service connection of type **Azure Resource Manager**, select the subscription and resource group to manage, and grant permissions to pipelines to use the connection.  

#### Pipeline Structure:
```
root  
├── mongodb.yaml                     # Deployment file for MongoDB  
└── src  
    ├── azure-pipelines.yml          # Azure Pipeline template  
    ├── backend  
    │   ├── azure-pipeline.yml       # Pipeline for backend (uses template)  
    │   └── k8s  
    │       └── deployment.yml       # Deployment file for backend  
    └── frontend  
        ├── azure-pipeline.yml       # Pipeline for frontend (uses template)  
        └── k8s  
            └── deployment.yml       # Deployment file for frontend  
```

#### Pipeline Stages
1. Build Docker Image and Push to ACR
Build a Docker image using the provided Dockerfile.
Tag the image with the current build number or Git commit SHA.
Push the built image to an Azure Container Registry (ACR).
2. Deploy to AKS
Deploy the application (backend, frontend, and MongoDB) to an AKS cluster using the respective Kubernetes manifest files (deployment.yml).
3. Cleanup
Retain the last 5 images in the ACR.
Remove older images to free up storage space.

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