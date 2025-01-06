resource_group_name = "MSA-ResourceGroup"
location            = "East US"

vnet_name           = "MSA-VNet"
subnet_name         = "AKS-Subnet"
vnet_address_space  = ["10.0.0.0/16"]
subnet_prefix       = ["10.0.1.0/24"]

aks_cluster_name    = "MSA-AKS"
node_count          = 2
node_size           = "Standard_DS2_v2"

acr_name            = "msaregistry"
