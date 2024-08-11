# Azure GUIDS
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

# Resource Group/Location
variable "location" {}
variable "resource_group" {}
variable "application_type" {}

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
  
