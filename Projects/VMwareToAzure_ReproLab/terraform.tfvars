# terraform.tfvars
# Purpose: Defines variable values

# Engineers
abrs_engineer = {
    Andrew = {
        alias = "Asipes"
        datastore = "Datastore 1"
    },
}

#######################################
# VCenter variables

vsphere_user = ""
vsphere_password = ""
vsphere_server = ""
vsphere_datacenter = ""
vsphere_cluster = "ESXi"
vsphere_template_folder = "Templates"

#######################################
# VM variables

vm_folder = "asipes"
vm_datastore = "Datastore 2"
vm_network = "VM_Switch_Network"
vm_alias = "Default"

#LINUX
linuxvm_count = 1
linuxvm_cpu = "2"
linuxvm_ram = "2048"
linuxvm_disk = 100
linuxvm_name = "ubuntuRCMVM"
linuxvm_guest_id= "ubuntu64Guest"
linuxvm_template_name = "Ubuntu-2204-Template"
linuxvm_domain = ""
linuxvm_rootpass = "P@ssw0rd"

#WINDOWS
winvm_count = 1
winvm_cpu = "4"
winvm_ram = "4096"
winvm_disk = 100
winvm_name = "WinRCMVM"
winvm_guest_id= "windows964Guest"
winvm_template_name = "Windows-2022-Template"

#WINDOWS APP
winappvm_count = 1
winappvm_cpu = "8"
winappvm_ram = "16384"
winappvm_disk = 100
winappvm_data_disk = 650
winappvm_name = "RCMApp"
winappvm_guest_id= "windows964Guest"
winappvm_template_name = "Windows-2022-Template"
