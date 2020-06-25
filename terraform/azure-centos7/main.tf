terraform {
  required_version = "> 0.12.0"
}

provider "azurerm" {
  version = "~> 2.15"
  features {}
  disable_terraform_partner_id = true
}
resource "random_id" "random" {
  byte_length = 4
}

resource "azurerm_resource_group" "default" {
  name     = "${var.tag_contact_name}-${random_id.random.hex}"
  location = "westus2"
  tags = {
    environment = "${var.tag_contact_name}_${random_id.random.hex}"
    X-Contact   = var.tag_contact_email
  }
}

resource "azurerm_virtual_network" "default" {
  name                = "${var.tag_contact_name}-${random_id.random.hex}"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  address_space       = ["10.10.0.0/16"]
  tags = {
    X-Contact = var.tag_contact_email
  }
}

resource "azurerm_subnet" "default" {
  name                 = "${var.tag_contact_name}-${random_id.random.hex}"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.10.2.0/24"]
}

resource "azurerm_public_ip" "default" {
  name                = "${var.tag_contact_name}-${random_id.random.hex}"
  location            = "westus2"
  resource_group_name = azurerm_resource_group.default.name
  allocation_method   = "Dynamic"
  tags = {
    environment = "${var.tag_contact_name}_${random_id.random.hex}"
    X-Contact   = var.tag_contact_email
  }
}

resource "azurerm_network_security_group" "default" {
  name                = "${var.tag_contact_name}-${random_id.random.hex}"
  location            = "westus2"
  resource_group_name = azurerm_resource_group.default.name
  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = {
    environment = "${var.tag_contact_name}_${random_id.random.hex}"
    X-Contact   = var.tag_contact_email
  }
}

resource "azurerm_network_interface" "default" {
  name                = "${var.tag_contact_name}-${random_id.random.hex}"
  location            = "westus2"
  resource_group_name = azurerm_resource_group.default.name

  ip_configuration {
    name                          = "${var.tag_contact_name}-${random_id.random.hex}"
    subnet_id                     = azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.default.id
  }

  tags = {
    environment = "${var.tag_contact_name}_${random_id.random.hex}"
    X-Contact   = var.tag_contact_email
  }
}

resource "azurerm_network_interface_security_group_association" "default" {
  network_interface_id      = azurerm_network_interface.default.id
  network_security_group_id = azurerm_network_security_group.default.id
}

resource "azurerm_storage_account" "default" {
  name                     = "${var.tag_contact_name}z${random_id.random.hex}"
  resource_group_name      = azurerm_resource_group.default.name
  location                 = "westus2"
  account_replication_type = "LRS"
  account_tier             = "Standard"

  tags = {
    environment = "${var.tag_contact_name}_${random_id.random.hex}"
    X-Contact   = var.tag_contact_email
  }
}

resource "azurerm_linux_virtual_machine" "default" {
  name                  = "centos7-${var.tag_contact_name}_${random_id.random.hex}"
  location              = "westus2"
  resource_group_name   = azurerm_resource_group.default.name
  network_interface_ids = [azurerm_network_interface.default.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  computer_name                   = "centos7-${var.tag_contact_name}-${random_id.random.hex}"
  admin_username                  = "centos"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "centos"
    public_key = file("")
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.default.primary_blob_endpoint
  }

  tags = {
    environment = "${var.tag_contact_name}_${random_id.random.hex}"
    X-Contact   = var.tag_contact_email
  }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo hostnamectl set-hostname ${format("${var.aws_key_pair_name}_${random_id.random.hex}_%02d", count.index + 1)}",
  #   ]
  # }
}

# data "aws_ami" "centos" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["chef-highperf-centos7-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["446539779517"]
# }
