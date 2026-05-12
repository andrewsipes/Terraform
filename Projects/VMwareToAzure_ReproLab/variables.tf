# variables.tf
# Purpose: Define all required details here values should be set in tfvars file

#######################################
# Variables

variable "abrs_engineer" {
  description = "list of engineers"
  type = map(object({
    alias = string
    datastore = string
  }))
}

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

variable "vsphere_cluster" {
  type        = string
  description = "VMWare vSphere cluster"
  default     = ""
}

variable "vsphere_template_folder" {
  type        = string
  description = "Template folder"
  default = "Templates"
}

#######################################
# VM variables

variable "vm_alias" {
  type        = string
  description = "Name of VM prefix"
  default     =  ""
}

variable "vm_folder" {
  type        = string
  description = "folder where cloned vms should reside"
  default = ""
}

variable "vm_datastore" {
  type        = string
  description = "Datastore used for the vSphere virtual machines"
}

variable "vm_network" {
  type        = string
  description = "Network used for the vSphere virtual machines"
}

#LINUX
variable "linuxvm_count" {
  description = "Number of VM"
  default     =  1
}

variable "linuxvm_cpu" {
  type        = string
  description = "Number of vCPU for the vSphere virtual machines"
  default     = "2"
}

variable "linuxvm_ram" {
  type        = string
  description = "Amount of RAM for the vSphere virtual machines (example: 2048)"
  default     = "2048"
}

variable "linuxvm_disk"{
    description = "Size of Disk, should be at least the size of the template disk"
    type = number
    default = 100
}

variable "linuxvm_name" {
  type        = string
  description = "The name of the vSphere virtual machines and the hostname of the machine"
  default     = "VM"
}

variable "linuxvm_domain" {
  type        = string
  description = "Linux virtual machine domain name for the machine. This, along with host_name, make up the FQDN of the virtual machine"
  default     = ""
}

variable "linuxvm_guest_id" {
  type        = string
  description = "The ID of virtual machines operating system"
}

variable "linuxvm_template_name" {
  type        = string
  description = "The template to clone to create the VM"
}


#WINDOWS
variable "winvm_count" {
  description = "Number of VM"
  default     =  1
}

variable "winvm_cpu" {
  type        = string
  description = "Number of vCPU for the vSphere virtual machines"
  default     = "2"
}

variable "winvm_ram" {
  type        = string
  description = "Amount of RAM for the vSphere virtual machines (example: 2048)"
  default     = "2048"
}

variable "winvm_disk"{
    description = "Size of Disk, should be at least the size of the template disk"
    type = number
    default = 100
}

variable "winvm_name" {
  type        = string
  description = "The name of the vSphere virtual machines and the hostname of the machine"
  default     = "VM"
}

variable "winvm_guest_id" {
  type        = string
  description = "The ID of virtual machines operating system"
}

variable "winvm_template_name" {
  type        = string
  description = "The template to clone to create the VM"
}

#WINDOWS APP
variable "winappvm_count" {
  description = "Number of VM"
  default     =  1
}

variable "winappvm_cpu" {
  type        = string
  description = "Number of vCPU for the vSphere virtual machines"
  default     = "2"
}

variable "winappvm_ram" {
  type        = string
  description = "Amount of RAM for the vSphere virtual machines (example: 2048)"
  default     = "2048"
}

variable "winappvm_disk"{
    description = "Size of Disk, should be at least the size of the template disk"
    type = number
    default = 100
}

variable "winappvm_data_disk"{
    description = "Size of Disk, should be at least the size of the template disk"
    type = number
    default = 100
}

variable "winappvm_name" {
  type        = string
  description = "The name of the vSphere virtual machines and the hostname of the machine"
  default     = "VM"
}

variable "winappvm_guest_id" {
  type        = string
  description = "The ID of virtual machines operating system"
}

variable "winappvm_template_name" {
  type        = string
  description = "The template to clone to create the VM"
}