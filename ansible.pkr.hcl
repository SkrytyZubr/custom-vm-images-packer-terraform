packer {
  required_plugins {
    azure = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/azure"
    }
    ansible = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

variable "clientid" {default=env("AZURE_CLIENT_ID")}
variable "clientsecret" {default=env("AZURE_SECRET")}
variable "subscriptionid" {default=env("AZURE_SUBSCRIPTION_ID")}
variable "tenantid" {default=env("AZURE_TENANT_ID")}
variable "resource_group" {default="rg_images"}
variable "image_name" {default="linuxWeb"}
variable "image_version" {default="0.0.1"}

source "azure-arm" "azurevm"{
    client_id = var.clientid
    client_secret = var.clientsecret
    subscription_id = var.subscriptionid
    tenant_id = var.tenantid

    managed_image_name = "${var.image_name}-v${var.image_version}"
    managed_image_resource_group_name = var.resource_group

    os_type = "Linux"
    image_publisher = "Canonical"
    image_offer = "UbuntuServer"
    image_sku = "18.04-LTS"
    location = "West Europe"
    vm_size = "Standard_DS2_v2"

    azure_tags = {
        version = var.image_version
        role = "WebServer"
    }
}

build {
  sources = ["source.azure-arm.azurevm"]

  provisioner "shell" {
    execute_command = "sudo sh -c '{{ .Vars }} {{ .Path}}'"
    inline = [
      "add-apt-repository ppa:ansible/ansible",
      "apt-get update",
      "apt-get install -y ansible"
    ]
  }

  provisioner "ansible-local" {
    playbook_file = "ansible/playbook.yml"
  }

  provisioner "shell" {
    execute_command = "sudo sh -c '{{ .Vars }} {{ .Path}}'"
    script          = "clean.sh"
  }

  provisioner "shell" {
    execute_command = "sudo sh -c '{{ .Vars }} {{ .Path}}'"
    inline = [
      "/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"
    ]
  }
}