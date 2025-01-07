# modules/aks/main.tf
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.cluster_name
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name           = "default"
    node_count     = var.node_count
    vm_size        = var.vm_size
    # vnet_subnet_id = var.subnet_id[0]
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }
}

# Have an issue: Workaround by run command line
# az aks update -n <cluster_name> -g <resource_group_name> --attach-acr <ACR_name>
# Grant AKS access to ACR
resource "azurerm_role_assignment" "aks_acr" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                           = var.acr_id
  skip_service_principal_aad_check = true

  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}