resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = false
}

resource "azurerm_role_assignment" "acr_pull" {
  principal_id         = var.aks_client_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr.id
}
