# Azure GUIDS
variable "subscription_id" { default ="c6b49f87-b44b-4f50-9328-64efe17053d2"}
variable "client_id" {default ="11958eb2-8495-4c38-b1e9-96fd3a42fb29"}
variable "client_secret" {default ="W3s8Q~DI0ZNUZ6eTDX4OcllNbHGIrz5UCEPHRbOh"}
variable "tenant_id" {default ="1d4ecdae-1850-4f9b-8f09-aedca77aa0f1"}

# Resource Group/Location
variable "location" {
  default     = "East US"
  }
variable "resource_group" {
     default     = "AzuredevopsRG"
}
variable "application_type" {
  default = "myapplication-ourobadiou"
}

# Network
variable virtual_network_name {}
variable address_prefix_test {
  default= ["10.5.1.0/24"]
}
variable address_space {
  default =  ["10.5.0.0/16"]
}


