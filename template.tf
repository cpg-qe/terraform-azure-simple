resource "azurerm_resource_group" "main" {
  count    = var.use_existing_resource_group ? 0 : 1
  name     = var.use_existing_resource_group ? var.resourceGroup : "${var.resourceGroup}_${random_id.id.hex}"
  location = var.region
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = [var.address_space]
  location            = var.use_existing_resource_group ? data.azurerm_resource_group.existing.location : azurerm_resource_group.main[0].location
  resource_group_name = var.resourceGroup
}

resource "azurerm_subnet" "internal" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = var.resourceGroup
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_prefix]
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = var.use_existing_resource_group ? data.azurerm_resource_group.existing.location : azurerm_resource_group.main[0].location
  resource_group_name = var.resourceGroup

  ip_configuration {
    name                          = "${var.prefix}-ipconfiguration"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-azure-vm"
  location              = var.use_existing_resource_group ? data.azurerm_resource_group.existing.location : azurerm_resource_group.main[0].location
  resource_group_name   = var.resourceGroup
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = var.vmSize[1]["type2"]

  storage_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku["image1"]
    version   = var.image_version
  }

  storage_os_disk {
    name              = "${var.prefix}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = var.hostname
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = var.environment[2]["env"]
  }
}

resource "azurerm_public_ip" "test" {
  name                = "${var.prefix}-PublicIp"
  location            = var.region
  resource_group_name = var.resourceGroup
  allocation_method   = "Static"

  tags = {
    Name = var.mapvar["name"]
  }
}

resource "azurerm_managed_disk" "example" {
  name                 = "${var.prefix}-azure-vm-disk1"
  location             = var.use_existing_resource_group ? data.azurerm_resource_group.existing.location : azurerm_resource_group.main[0].location
  resource_group_name  = var.resourceGroup
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.diskSizeInGB

  tags = var.objectVar
}

resource "azurerm_virtual_machine_data_disk_attachment" "example" {
  managed_disk_id    = azurerm_managed_disk.example.id
  virtual_machine_id = azurerm_virtual_machine.main.id
  lun                = "10"
  caching            = "ReadWrite"
}

resource "random_id" "id" {
  byte_length = 2
}

data "azurerm_resource_group" "existing" {
  name = var.resourceGroup
  count = var.use_existing_resource_group ? 1 : 0
}
