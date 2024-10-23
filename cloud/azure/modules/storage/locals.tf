locals {
  tags = merge({ "Environment" = format("%s", var.global.environment) }, { "Region" = format("%s", var.global.location) }, var.extra_tags)
  rg_list = { for k, v in var.rg :
    k => {
      name     = k
      location = v.location
  } }
  # resourcegroup_list = flatten([for resource_group in var.resource_groups :
  #   {
  #     name     = resource_group.name
  #     location = resource_group.location
  # }])
  # storage_account_list = {
  #   for storage_account, storage_accounts in var.storage : storage_account => storage_accounts
  # }
  storage_account_list = flatten([for storage_account, storage_accounts in var.storage :
    {
      rg                   = storage_accounts.rg
      name                     = storage_account
      file_share_name          = storage_accounts.file_share_name
      location                 = storage_accounts.location
      account_tier             = storage_accounts.account_tier
      vnet_allowed             = storage_accounts.vnet_allowed
      account_replication_type = storage_accounts.account_replication_type
  }])
  subnet_list = flatten([for vnetname, vnetdata in var.network.vnets :
    [for subnet, subnets in vnetdata.subnets :
      {
        rg                   = vnetdata.rg
        subnetname           = subnet
        virtual_network_name = vnetname
        address_prefixes     = subnets.addressspace
        serviceendpoints     = subnets.serviceendpoints
        location             = vnetdata.location

  }]])
}