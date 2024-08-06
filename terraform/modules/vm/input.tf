
variable "application_type" {}
variable "resource_type" {}
variable "public_ip_address_id" {}
variable "location" {}
variable "subnet_id" {}
variable "resource_group" {}
variable "admin_username" {
   description = "username"
   default     = "ourobadiou"
}

variable "admin_password" {
   description  = "password"
   default      = "B@diou2015"
}
