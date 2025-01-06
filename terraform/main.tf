provider "azurerm" {
  features {}
}

# Create Resource Group
module "resource_group" {
  source = "./modules/resource_group"
  name   = var.resource_group_name
  location = var.location
}

# Create Virtual Network and Subnet
module "vnet" {
  source = "./modules/vnet"
  resource_group_name = module.resource_group.name
  vnet_name           = var.vnet_name
  subnet_name         = var.subnet_name
  address_space       = var.vnet_address_space
  subnet_prefix       = var.subnet_prefix
  location            = var.location
}

# Create AKS Cluster
module "aks" {
  source              = "./modules/aks"
  resource_group_name = module.resource_group.name
  subnet_id           = module.vnet.subnet_id
  cluster_name        = var.aks_cluster_name
  location            = var.location
  node_count          = var.node_count
  node_size           = var.node_size
}

# Create Azure Container Registry
module "acr" {
  source 
