# Azure GUIDS
#variable "subscription_id" { default ="c6b49f87-b44b-4f50-9328-64efe17053d2"}
variable "subscription_id" { default ="44ada2e4-89f9-41cc-8efc-3cf76cd05c0c"} 
variable "client_id" {default ="89ff65cf-ded6-4154-b737-961b33bd070a"}
variable "client_secret" {default ="gAw8Q~pM4kO673KOTEvN~Er54YrC86018wNpUawh"}
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
variable virtual_network_name {
  default = "myapplication-ourobadiou"
}
variable "address_space" {
  default = ["10.0.0.0/16"]  # Valeur par défaut générique pour le réseau virtuel
}

variable "address_prefix_test" {
  default = ["10.0.1.0/24"]  # Valeur par défaut générique pour le sous-réseau
}


