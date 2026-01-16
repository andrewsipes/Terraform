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

vm_count = 3
vm_folder = ""
vm_datastore = ""
vm_network = ""
vm_cpu = "4"
vm_ram = "4096"
vm_disk = 100
vm_alias = ""
vm_name = "Ubuntu"
vm_domain = ""
vm_guest_id= "ubuntu64Guest"
vm_template_name = "Ubuntu-2204-Template"