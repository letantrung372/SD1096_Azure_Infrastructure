variable "aks_subnet_prefix" {
    default="10.0.1.0/24"
}
variable "location" {}
variable "resource_group_name" {}
variable "vnet_name" {}
variable "vnet_address_space" {
    default="10.0.0.0/16"
}