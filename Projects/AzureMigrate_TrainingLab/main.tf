# main.tf
# Purpose: Main template file that deploys ansible lab

## vSphere
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

# Create VMs

#linux
resource "vsphere_virtual_machine" "linuxvm" {
  count = var.vm_count

  name             = "${var.vm_alias}-${var.vm_name}" //-${count.index + 1}"
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
    label = "${var.vm_alias}-${var.linuxvm_name}-disk"//${count.index + 1}-disk"
    size  = data.vsphere_virtual_machine.linuxtemplate.disks[0].size
    thin_provisioned = data.vsphere_virtual_machine.linuxtemplate.disks[0].thin_provisioned

    unit_number = data.vsphere_virtual_machine.linuxtemplate.disks[0].unit_number
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name = "${var.vm_alias}-${var.linuxvm_name}" //-${count.index + 1}"
        domain    = var.vm_domain
      }     
      network_interface {}
      timeout = 30
    }
  }
}

resource "vsphere_virtual_machine" "winvm" {
  count = var.vm_count

  name             = "${var.vm_alias}-${var.winvm_name}" //-${count.index + 1}"
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
    label = "${var.vm_alias}-${var.winvm_name}-disk" //-${count.index + 1}-disk"
    size  = data.vsphere_virtual_machine.wintemplate.disks[0].size
    thin_provisioned = data.vsphere_virtual_machine.wintemplate.disks[0].thin_provisioned

    unit_number = data.vsphere_virtual_machine.wintemplate.disks[0].unit_number
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.wintemplate.id
    customize {
      linux_options {
        host_name = "${var.vm_alias}-${var.winvm_name}" //-${count.index + 1}"
        domain    = var.vm_domain
      }     
      network_interface {}
      timeout = 30
    }
  }
}

resource "vsphere_virtual_machine" "winappvm" {
  count = var.vm_count

  name             = "${var.vm_alias}-${var.winappvm_name}" //-${count.index + 1}"
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
    label = "${var.vm_alias}-${var.winappvm_name}-disk" //-${count.index + 1}-disk"
    size  = data.vsphere_virtual_machine.template.disks[0].size
    thin_provisioned = data.vsphere_virtual_machine.winapptemplate.disks[0].thin_provisioned

    unit_number = data.vsphere_virtual_machine.winapptemplate.disks[0].unit_number
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.winapptemplate.id
    customize {
      linux_options {
        host_name = "${var.vm_alias}-${var.winappvm_name}" //-${count.index + 1}"
        domain    = var.vm_domain
      }     
      network_interface {}
      timeout = 30
    }
  }
}