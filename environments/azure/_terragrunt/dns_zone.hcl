locals {
  config   = yamldecode(file(find_in_parent_folders("config.yaml")))
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env_name = local.env_vars.locals.subscription

  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
  common_tags = local.common_vars.common_tags
}

# Resource Group module
terraform {
  source = "../../../../../cloud/azure/modules/dns_zone"
}

inputs = {
  dns_zones = { for dns_zone in local.config.dns_zones : dns_zone.name => {
    name                = dns_zone.name
    resource_group_name = dns_zone.resource_group_name
    tags                = merge(local.common_tags, dns_zone.resource_tags)
    }
  }
}