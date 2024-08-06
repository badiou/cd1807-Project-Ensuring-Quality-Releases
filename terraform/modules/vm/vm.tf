resource "azurerm_network_interface" "test" {
  name                = "udacity-nic"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip_address_id
  }
}

resource "azurerm_linux_virtual_machine" "test" {
  name                = "${var.application_type}-${var.resource_type}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"
  size                = "Standard_DS2_v2"
  admin_username      = "${var.admin_username}"
  admin_password      = "${var.admin_password}"
  disable_password_authentication = false
  network_interface_ids = [azurerm_network_interface.test.id]

  # admin_ssh_key {
  #   username   = "ourobadiou"
  #   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDEL7hBFBLjSOBQKNXZl7zjOTIMa+YCmXrq18P9FKvCKF19ZqAVMrWYnaplO6JU7xegaevVkUvFcoRfA9X3NljZrajFS+aBUzr/wUkndDUv/HAkYxguyuURm1o7WP+GVc5ov4klVmpRtobNGj5qVLzswI4r7DuwQbsg9HxBSMx5m5cWl1hYb4WmWX487WMpO4ISmPKF4N76h7d08PNY51S//LQeAWNV6hRNInvjnYthR9pdmvR5urh5LKPXAtZsSl62dgds2uyhn12kbKMxGnimTgfYesBAaHAovlFx/I8dcSNuvMEbvWXGa7e6kMrgUnwnc84t3Sr039ur7Z8t47g7UEbTqX5XbrMPLLPsokvvk2GB2VAyvtir2xJg1elSzyOvSZo0n+FlV7Pjvhw2ge+v6hNe0kzGuTwmyOe1VGtqvo/yTDictLV/dR5YWLSMeRp7CJYrKaKl1dmw92QdF/Et2XXmnom2EaEnMcoyU0/JOURdJWoTEU+6Pw3KTJuLcN8="
  # }
  os_disk {
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}



