terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}


module "resource_group" {
  source               = "./modules/resource_group"
  resource_group_name      = var.resource_group_name
  location  = var.location
}

module "network" {
  source               = "./modules/network"
  resource_group_name  = var.resource_group_name
  location            = var.location
  vnet_name           = var.vnet_name
  vnet_address_space  = var.vnet_address_space
  aks_subnet_prefix   = var.aks_subnet_prefix
  # db_subnet_prefix    = var.db_subnet_prefix
  depends_on = [module.resource_group]
}

module "acr" {
  source              = "./modules/acr"
  resource_group_name = var.resource_group_name
  location           = var.location
  acr_name           = var.acr_name
  sku                = "Basic"
  depends_on = [module.resource_group]
}

module "aks" {
  source               = "./modules/aks"
  resource_group_name  = module.resource_group.name
  location            = var.location
  cluster_name        = var.cluster_name
  kubernetes_version  = var.kubernetes_version
  subnet_id           = module.network.subnet_id
  acr_id              = module.acr.acr_id
  node_count         = var.node_count
  vm_size            = var.vm_size
  dns_service_ip      = var.dns_service_ip
  aks_subnet_prefix = var.aks_subnet_prefix
  depends_on = [module.resource_group, module.network, module.acr]
}