terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  tenant_id       = "c3da54c9-a4bc-4304-b2c8-f95e3c766094"
  client_id       = "c3c06b56-b27e-4973-9daa-122dd1f57c63"
  client_secret   = "78Q8Q~NrfKqfchPsGyWZJvYFHCh_Q3-iU7L7scjL"
  subscription_id = "acb97d0a-42c8-4392-b7a6-04030714a148"

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
  depends_on = [module.resource_group, module.network, module.acr]
}