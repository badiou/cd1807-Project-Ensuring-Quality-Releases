variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "client_id" {
  description = "Azure client ID"
  type        = string
}

variable "client_secret" {
  description = "Azure client secret"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

variable "location" {
  description = "Azure location for resources"
  type        = string
}

variable "resource_group" {
  description = "Name of the resource group"
  type        = string
}

variable "application_type" {
  description = "Type or name of the application"
  type        = string
}

variable "virtual_network_name" {
  description = "Name of the virtual network"
  type        = string
  default     = ""
}

variable "address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
}

variable "address_prefix_test" {
  description = "Address prefix for the subnet"
  type        = list(string)
}
