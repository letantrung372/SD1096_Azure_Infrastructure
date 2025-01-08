resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                = var.sku
  admin_enabled      = false

  identity {
    type = "SystemAssigned"
  }
}


# Work-aground: run Azure CLI to assign ACR_Push to ACR
# az role assignment create --assignee 3a9b7fff-a752-4ae8-a77f-312ac0ef3f69 --scope /subscriptions/acb97d0a-42c8-4392-b7a6-04030714a148/resourceGroups/practical-devops-rg/providers/Microsoft.ContainerRegistry/registries/msademoacr --role AcrPush

# Role assignment for ACR Push
resource "azurerm_role_assignment" "acr_push" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPush"
  principal_id         = azurerm_container_registry.acr.identity[0].principal_id
}

# Role assignment for ACR Pull
resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_container_registry.acr.identity[0].principal_id
}