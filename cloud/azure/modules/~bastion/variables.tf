variable "common_location" {
}
variable "common_resource_group" {
}

variable "vnets" {
  
}

variable "network" {}
variable "firewall_enabled" {
  default = "false"
}

variable "bastion_enabled" {
  default = "false"
}


variable "env" {
  type = string
}

variable "extra_tags" {
  
}
variable "custom_data" {}
variable "bastion_vm_public_key" {}