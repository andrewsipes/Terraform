# terraform.tfvars
# Purpose: Defines variable values

#######################################
# VCenter variables

#vsphere_user = 
#vsphere_password = 
#vsphere_server =
#vsphere_datacenter =
vsphere_cluster = "ESXi"
vsphere_template_folder = "Templates"

#######################################
# VM variables

vm_folder = "Migrate Training"
vm_datastore = "Datastore 2"
vm_network = "VM_Switch_Network"
vm_alias = "Trainer"
vm_domain = ""

#LINUX
linuxvm_count = 1
linuxvm_cpu = "2"
linuxvm_ram = "2048"
linuxvm_disk = 100
linuxvm_name = "Ubuntu"
linuxvm_guest_id= "ubuntu64Guest"
linuxvm_template_name = "Ubuntu-2204-Template"

#WINDOWS
winvm_count = 1
winvm_cpu = "4"
winvm_ram = "4096"
winvm_disk = 100
winvm_name = "Windows"
winvm_guest_id= "windows9_64Guest"
winvm_template_name = "Windows-2022-Template"

#WINDOWS APP
winappvm_count = 1
winappvm_cpu = "4"
winappvm_ram = "4096"
winappvm_disk = 100
winappvm_name = "MigrateAppliance"
winappvm_guest_id= "windows9_64Guest"
winappvm_template_name = "Windows-2022-Template"