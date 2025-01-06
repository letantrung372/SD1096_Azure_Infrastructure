variable "resource_group_name" {
  default = "MSA-ResourceGroup"
}
variable "location" {
  default = "East US"
}
variable "vnet_name" {
  default = "MSA-VNet"
}
variable "subnet_name" {
  default = "AKS-Subnet"
}
variable "vnet_address_space" {
  default = ["10.0.0.0/16"]
}
variable "subnet_prefix" {
  default = ["10.0.1.0/24"]
}
variable "aks_cluster_name" {
  default = "MSA-AKS"
}
variable "node_count" {
  default = 2
}
variable "node_size" {
  default = "Standard_DS2_v2"
}
variable "acr_name" {
  default = "msaregistry"
}
