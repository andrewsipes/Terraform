# terraform.tfvars
# Purpose: Defines variable values

#######################################
# VCenter variables

#vsphere_user = 
#vsphere_password = 
#vsphere_server =
#vsphere_datacenter =
vsphere_template_folder = "Templates"

#######################################
# VM variables

vm_count = 3
vm_name_prefix = "Asipes-AnsibleLab-"
vm_datastore = "Datastore 1"
vm_network = "VM_Switch_Network"
vm_cpu = "4"
vm_ram = "4096"
vm_name = "Ubuntu"
vm_template_name = "Ubuntu-2204-Template"