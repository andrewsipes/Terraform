# main.tf
# Purpose: Main template file that deploys the training lab

# vSphere
provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

# VM
data "vsphere_datastore" "ds" {
  for_each      = var.abrs_engineer
  name          = each.value.datastore
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

# Create VMs

#linux
resource "vsphere_virtual_machine" "linuxvm" {
  for_each = var.abrs_engineer

  name             = "${each.value.alias}-${var.linuxvm_name}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.ds[each.key].id
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
    label = "${each.value.alias}-${var.linuxvm_name}-disk"
    size  = data.vsphere_virtual_machine.linuxtemplate.disks[0].size
    thin_provisioned = data.vsphere_virtual_machine.linuxtemplate.disks[0].thin_provisioned

    unit_number = data.vsphere_virtual_machine.linuxtemplate.disks[0].unit_number
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.linuxtemplate.id
    customize {
      linux_options {
        host_name = "${each.value.alias}-${var.linuxvm_name}"
        domain    = var.linuxvm_domain
        time_zone = "America/New_York"
      }     
      network_interface{}
      timeout = 30

    }
  }
}

resource "vsphere_virtual_machine" "winvm" {
  for_each = var.abrs_engineer

  name             = "${each.value.alias}-${var.winvm_name}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.ds[each.key].id
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
    label = "${each.value.alias}-${var.winvm_name}-disk"
    size  = data.vsphere_virtual_machine.wintemplate.disks[0].size
    thin_provisioned = data.vsphere_virtual_machine.wintemplate.disks[0].thin_provisioned

    unit_number = data.vsphere_virtual_machine.wintemplate.disks[0].unit_number
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.wintemplate.id
    customize {
      windows_options {
        computer_name = "${each.value.alias}-${var.winvm_name}"
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
  for_each = var.abrs_engineer

  name             = "${each.value.alias}-${var.winappvm_name}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.ds[each.key].id
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
    label = "${each.value.alias}-${var.winappvm_name}-disk"
    size  = data.vsphere_virtual_machine.winapptemplate.disks[0].size
    thin_provisioned = data.vsphere_virtual_machine.winapptemplate.disks[0].thin_provisioned

    unit_number = data.vsphere_virtual_machine.winapptemplate.disks[0].unit_number
  }

  disk {
    label = "${each.value.alias}-${var.winappvm_name}-data-disk"
    size  = var.winappvm_data_disk
    thin_provisioned = true
    unit_number = 1
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.winapptemplate.id
    customize {
     windows_options {
        computer_name = "${each.value.alias}-${var.winappvm_name}"
        run_once_command_list = ["cmd.exe /c net user Administrator /logonpasswordchg:yes",
        "cmd.exe /c tzutil /s \"Eastern Standard Time\"",
        "cmd.exe /c powershell -Command \"Set-NetConnectionProfile -Name 'corp.microsoft.com' -NetworkCategory Private\"",
        "powershell Initialize-Disk -Number 1",
        "powershell New-Partition -DiskNumber 1 -DriveLetter D -UseMaximumSize | Format-Volume -FileSystem NTFS -NewFileSystemLabel 'DATA' -Confirm:$false",
        "powershell $ProgressPreference = 'SilentlyContinue'; wget 'https://aka.ms/V2ARcmApplianceCreationPowershellZip' -OutFile C:\\users\\administrator\\downloads\\asrzip.zip",
        "powershell Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Confirm:$false",
        "powershell Install-Module 7Zip4PowerShell -Scope CurrentUser -Force -Confirm:$false -Verbose -ErrorAction SilentlyContinue",
        "powershell Expand-7Zip -ArchiveFileName 'C:\\users\\administrator\\downloads\\asrzip.zip' -TargetPath 'C:\\users\\administrator\\downloads\\asr'",
        "powershell 'C:\\users\\administrator\\downloads\\DRAppliance\\DRInstaller.ps1'",
        "cmd.exe /c powershell -Command \"logoff\"",]
      }     
      network_interface {}
      timeout = 30
    }
  }
}