# Azure 

variable "subscription_id" {
    default = "c6b49f87-b44b-4f50-9328-64efe17053d2"
}
variable "client_id" {
    default = "0cacfd8f-8987-4c8c-8293-c168a3d33602"
}
variable "client_secret" {
    default = "szM8Q~gZ.vv~tHr8_XOk9V-abCX4r1b~R20NGbMG"
}
variable "tenant_id" {
    default = "1d4ecdae-1850-4f9b-8f09-aedca77aa0f1"
}

# Resource Group/Location
variable "location" {
    default = "East US"
}
variable "resource_group" {
    default = "AzuredevopsRG"
}
variable "application_type" {
    default = "myapplication-ourobadiou"
}

# Network
variable "virtual_network_name" {}
variable "address_prefix_test" {
    default = ["10.5.1.0/24"]
}
variable "address_space" {
    default=["10.5.0.0/16"]
}

#Credentials
variable "admin_username" {
    default = "ourobadiou"
}
variable "public_key" {
    default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDEL7hBFBLjSOBQKNXZl7zjOTIMa+YCmXrq18P9FKvCKF19ZqAVMrWYnaplO6JU7xegaevVkUvFcoRfA9X3NljZrajFS+aBUzr/wUkndDUv/HAkYxguyuURm1o7WP+GVc5ov4klVmpRtobNGj5qVLzswI4r7DuwQbsg9HxBSMx5m5cWl1hYb4WmWX487WMpO4ISmPKF4N76h7d08PNY51S//LQeAWNV6hRNInvjnYthR9pdmvR5urh5LKPXAtZsSl62dgds2uyhn12kbKMxGnimTgfYesBAaHAovlFx/I8dcSNuvMEbvWXGa7e6kMrgUnwnc84t3Sr039ur7Z8t47g7UEbTqX5XbrMPLLPsokvvk2GB2VAyvtir2xJg1elSzyOvSZo0n+FlV7Pjvhw2ge+v6hNe0kzGuTwmyOe1VGtqvo/yTDictLV/dR5YWLSMeRp7CJYrKaKl1dmw92QdF/Et2XXmnom2EaEnMcoyU0/JOURdJWoTEU+6Pw3KTJuLcN8="
}
  
