# main.tf
# Purpose: Main template file that deploys the V2A RCM Lab

#######################################
# PROVIDERS

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
    vsphere = {
      source = "hashicorp/vsphere"
      version = "~>2.12.0"
    }
  }
}

provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

provider "azurerm" {
   features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

#######################################
# VSPHERE
data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

# VM
data "vsphere_datastore" "ds" {
  name          = var.vm_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vm_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "linuxtemplate" {
  name          = "/${var.vsphere_datacenter}/vm/${var.vsphere_template_folder}/${var.linuxvm_template_name}"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "wintemplate" {
  name          = "/${var.vsphere_datacenter}/vm/${var.vsphere_template_folder}/${var.winvm_template_name}"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "winapptemplate" {
  name          = "/${var.vsphere_datacenter}/vm/${var.vsphere_template_folder}/${var.winappvm_template_name}"
  datacenter_id = data.vsphere_datacenter.dc.id
}

#######################################
# AZURE

resource "azurerm_resource_group" "rg" {
  name = "${var.az_prefix}-V2ARCM"
  location = var.az_rg_location
}

resource "azurerm_recovery_services_vault" "rsv" {
  name = "${var.az_prefix}-V2ARCM-RSV"
  location =  var.az_rg_location
  resource_group_name = azurerm_resource_group.rg.name
  sku = "Standard"
}

resource "azurerm_storage_account" "sa" {
  name = var.az_saname
  resource_group_name = azurerm_resource_group.rg.name
  location =  var.az_rg_location
  account_tier = "Standard"
  account_replication_type = "LRS"
  min_tls_version = "TLS1_2"
  https_traffic_only_enabled = true
  shared_access_key_enabled = true 

  tags = {
  SecurityControl = "Ignore"
  }
}
#######################################
# CREATE VM

#linux
resource "vsphere_virtual_machine" "linuxvm" {

  count = var.linuxvm_count
  name = var.linuxvm_count > 1 ? "${var.vm_alias}-${var.linuxvm_name}-${count.index + 1}" : "${var.vm_alias}-${var.linuxvm_name}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.ds.id
  folder = var.vm_folder
  num_cpus = var.linuxvm_cpu
  memory   = var.linuxvm_ram
  guest_id = data.vsphere_virtual_machine.linuxtemplate.guest_id
  firmware = data.vsphere_virtual_machine.linuxtemplate.firmware
  scsi_type = data.vsphere_virtual_machine.linuxtemplate.scsi_type

  network_interface {
    network_id = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.linuxtemplate.network_interface_types[0]
  }

  disk {
    label = var.linuxvm_count > 1 ? "${var.vm_alias}-${var.linuxvm_name}-${count.index + 1}-disk" : "${var.vm_alias}-${var.linuxvm_name}-disk"
    size  = data.vsphere_virtual_machine.linuxtemplate.disks[0].size
    thin_provisioned = data.vsphere_virtual_machine.linuxtemplate.disks[0].thin_provisioned

    unit_number = data.vsphere_virtual_machine.linuxtemplate.disks[0].unit_number
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.linuxtemplate.id
    # Customize Blocks can be hit or miss with linux, you may not get an IP address if using this
    # Generalization script on the template will prompt for a VM name automatically
    # customize {
    #   linux_options {
    #     host_name = "${var.vm_alias}-${var.linuxvm_name}"
    #     domain    = var.linuxvm_domain
    #     time_zone = "America/New_York"
    #   }     
    #   network_interface{}
    #   timeout = 30
    # }
  }
}

resource "vsphere_virtual_machine" "winvm" {
  count = var.winvm_count
  name = var.winvm_count > 1 ? "${var.vm_alias}-${var.winvm_name}-${count.index + 1}" : "${var.vm_alias}-${var.winvm_name}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.ds.id
  folder = var.vm_folder
  num_cpus = var.winvm_cpu
  memory   = var.winvm_ram
  guest_id = data.vsphere_virtual_machine.wintemplate.guest_id
  firmware = data.vsphere_virtual_machine.wintemplate.firmware
  scsi_type = data.vsphere_virtual_machine.wintemplate.scsi_type

  network_interface {
    network_id = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.wintemplate.network_interface_types[0]
  }

  disk {
    label = var.winvm_count > 1 ? "${var.vm_alias}-${var.winvm_name}-${count.index + 1}-disk" : "${var.vm_alias}-${var.winvm_name}-disk"
    size  = data.vsphere_virtual_machine.wintemplate.disks[0].size
    thin_provisioned = data.vsphere_virtual_machine.wintemplate.disks[0].thin_provisioned

    unit_number = data.vsphere_virtual_machine.wintemplate.disks[0].unit_number
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.wintemplate.id
    customize {
      windows_options {
        computer_name = "${var.vm_alias}-${var.winvm_name}"
        run_once_command_list = ["cmd.exe /c net user Administrator /logonpasswordchg:yes",
        "cmd.exe /c tzutil /s \"Eastern Standard Time\"", 
        "powershell Disable-NetFirewallRule -DisplayGroup 'Windows Management Instrumentation (WMI)'",
        "cmd.exe /c powershell -Command \"Set-NetConnectionProfile -Name 'corp.microsoft.com' -NetworkCategory Private\"",
        "cmd.exe /c powershell -Command \"logoff\"",]
      }    
      network_interface {}
      timeout = 30
    }
  }
}

resource "vsphere_virtual_machine" "winappvm" {
  count = var.winappvm_count
  name = var.winappvm_count > 1 ? "${var.vm_alias}-${var.winappvm_name}-${count.index + 1}" : "${var.vm_alias}-${var.winappvm_name}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.ds.id
  folder = var.vm_folder
  num_cpus = var.winappvm_cpu
  memory   = var.winappvm_ram
  guest_id = data.vsphere_virtual_machine.winapptemplate.guest_id
  firmware = data.vsphere_virtual_machine.winapptemplate.firmware
  scsi_type = data.vsphere_virtual_machine.winapptemplate.scsi_type

  network_interface {
    network_id = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.winapptemplate.network_interface_types[0]
  }

  disk {
    label = var.winappvm_count > 1 ? "${var.vm_alias}-${var.winappvm_name}-${count.index + 1}-disk" : "${var.vm_alias}-${var.winappvm_name}-disk"
    size  = data.vsphere_virtual_machine.winapptemplate.disks[0].size
    thin_provisioned = data.vsphere_virtual_machine.winapptemplate.disks[0].thin_provisioned

    unit_number = data.vsphere_virtual_machine.winapptemplate.disks[0].unit_number
  }

  disk {
    label = var.winappvm_count > 1 ? "${var.vm_alias}-${var.winappvm_name}-${count.index + 1}-data-disk" : "${var.vm_alias}-${var.winappvm_name}-data-disk"
    size  = var.winappvm_data_disk
    thin_provisioned = true
    unit_number = 1
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.winapptemplate.id
    customize {
     windows_options {
        computer_name = "${var.vm_alias}-${var.winappvm_name}"
        run_once_command_list = ["cmd.exe /c net user Administrator /logonpasswordchg:yes",
        "cmd.exe /c tzutil /s \"Eastern Standard Time\"",
        "cmd.exe /c powershell -Command \"Set-NetConnectionProfile -Name 'corp.microsoft.com' -NetworkCategory Private\"",
        "powershell Initialize-Disk -Number 1",
        "powershell New-Partition -DiskNumber 1 -DriveLetter D -UseMaximumSize | Format-Volume -FileSystem NTFS -NewFileSystemLabel 'DATA' -Confirm:$false",
        "powershell Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Confirm:$false",
        "powershell Install-Module 7Zip4PowerShell -Scope CurrentUser -Force -Confirm:$false -Verbose -ErrorAction SilentlyContinue",
        "powershell $ProgressPreference = 'SilentlyContinue'; wget 'https://aka.ms/V2ARcmApplianceCreationPowershellZip' -OutFile C:\\users\\administrator\\downloads\\asrzip.zip",
        "powershell Expand-7Zip -ArchiveFileName 'C:\\users\\administrator\\downloads\\asrzip.zip' -TargetPath 'C:\\users\\administrator\\downloads\\asr'",
        "powershell cd 'C:\\Users\\Administrator\\Downloads\\asr\\DRAppliance'; .\\DRInstaller.ps1; logoff"]
      }     
      network_interface {}
      timeout = 30
    }
  }
}