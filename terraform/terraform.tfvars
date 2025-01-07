# terraform.tfvars
resource_group_name = "practical-devops-rg"
location           = "southeastasia"
vnet_name          = "msa-vnet"
vnet_address_space = "10.0.0.0/16"
aks_subnet_prefix  = "10.0.1.0/24"
# db_subnet_prefix   = "10.0.2.0/24"
acr_name           = "msademoacr"
cluster_name       = "msa-aks-cluster"
kubernetes_version = "1.30.0"
node_count         = 2
vm_size            = "Standard_DS2_v2"