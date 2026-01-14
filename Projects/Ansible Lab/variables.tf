# variables.tf
# Purpose: Define all required details here values should be set in tfvars file

#######################################
# VCenter variables

variable "vsphere_user" {
  description = "vSphere username"
  type        = string
}

variable "vsphere_password" {
  description = "vSphere password"
  type        = string
}

variable "vsphere_server" {
  description = "vSphere server"
  type        = string
}

variable "vsphere_datacenter" {
  description = "vSphere datacenter"
  type        = string
}

variable "vsphere_template_folder" {
  type        = string
  description = "Template folder"
  default = "Templates"
}

#######################################
# VM variables

variable "vm_count" {
  description = "Number of VM"
  default     =  1
}

variable "vm_name_prefix" {
  type        = string
  description = "Name of VM prefix"
  default     =  "AnsibleLab-"
}

variable "vm_datastore" {
  type        = string
  description = "Datastore used for the vSphere virtual machines"
}

variable "vm_network" {
  type        = string
  description = "Network used for the vSphere virtual machines"
}

#variable "vm_linked_clone" {
#  type        = string
#  description = "Use linked clone to create the vSphere virtual machine from the template (true/false). If you would like to use the linked clone feature, your template need to have one and only one snapshot"
#  default     = "false"
#}

variable "vm_cpu" {
  type        = string
  description = "Number of vCPU for the vSphere virtual machines"
  default     = "2"
}

variable "vm_ram" {
  type        = string
  description = "Amount of RAM for the vSphere virtual machines (example: 2048)"
  default     = "2048"
}

variable "vm_name" {
  type        = string
  description = "The name of the vSphere virtual machines and the hostname of the machine"
  default     = "VM"
}

#variable "vm-guest-id" {
#  type        = string
#  description = "The ID of virtual machines operating system"#}

variable "vm_template_name" {
  type        = string
  description = "The template to clone to create the VM"
}