locals {
  rg_list = { for k, v in var.rg :
    k => {
      name     = k
      location = v.location
  } }
  vnet_list = flatten(
    [for vnetname, vnetdata in var.network.vnets : 
      {
        vnetname = vnetname
        vnet_address_space = vnetdata.vnet_address_space
        location = vnetdata.location
        rg = vnetdata.rg
        type = vnetdata.type
      }
  ])
  hub_vnet = flatten(
    [for vnetname, vnetdata in var.network.vnets : 
      {
        vnetname = vnetname
        vnet_address_space = vnetdata.vnet_address_space
        location = vnetdata.location
        rg = vnetdata.rg
        type = vnetdata.type
      } if vnetdata.type == "hub"
  ])
  subnet_list = flatten([for vnet, vnetdata in var.network.vnets :
    [for subnet, subnets in vnetdata.subnets :
      {
        rg                   = vnetdata.rg
        subnetname           = subnet
        virtual_network_name = vnet
        address_prefixes     = subnets.addressspace
        serviceendpoints     = subnets.serviceendpoints
        location             = vnetdata.location
  }]])
  # hub_vnet = [for vnet, vnetdata in var.network.vnets : vnet if vnetdata.type == "hub"]
  bastion_list = { for bastion, bastiondata in var.network.vnets : bastion => bastiondata if bastiondata.bastion_enabled == true }
  bastion_vm_list = flatten([for vmname, vms in var.network.bastion_vms: 
    {
      vmname = vmname
      rg = vms.rg
      vnet = vms.vnet
      subnet = vms.subnet
      location = vms.location
      username = vms.username
      size = vms.size
      source_image_reference = vms.source_image_reference
      os_disk = vms.os_disk
    } if vms.enabled == true
  ])
  bastion_vm_role_assignment_list = flatten([for vmname, vms in local.bastion_vm_list:
                                      flatten([for objectid in try(vms.vm_aad_admin_login_group_object_ids, var.global.rbac_group_object_ids):
                                      {
                                          vmname = "${vms.vnet}-${vms.subnet}"
                                          objectid = objectid
                                      }])
  ])
}