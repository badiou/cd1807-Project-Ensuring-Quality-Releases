# Azure GUIDS
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

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

variable application_type {
  default =  ["10.5.0.0/16"]
}
