locals {
  config   = yamldecode(file(find_in_parent_folders("config.yaml")))
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env_name = local.env_vars.locals.subscription

  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
  common_tags = local.common_vars.common_tags
}

terraform {
  source = "../../../../../cloud/azure/modules/aks_node_pool"
}

dependency "resource_group" {
  config_path                             = "${get_terragrunt_dir()}/../resource_group"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "apply", "destroy", "output"]
  skip_outputs                            = true
}

dependency "virtual_network" {
  config_path                             = "${get_terragrunt_dir()}/../virtual_network"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "apply", "destroy", "output"]
  skip_outputs                            = true
}

dependency "subnet" {
  config_path                             = "${get_terragrunt_dir()}/../subnet"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "apply", "destroy", "output"]
  mock_outputs = {
    subnets_output = {
      "aks-node-pool-subnet1" = {
        id = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.Network/virtualNetworks/virtualNetworksValue/subnets/subnetValue"
      }
    }
  }
}

dependency "aks" {
  config_path                             = "${get_terragrunt_dir()}/../aks"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "apply", "destroy", "output"]
  mock_outputs = {
    aks_clusters_output = {
      "dummy-cluster-name" = {
        id = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/dummy-rg/providers/Microsoft.ContainerService/managedClusters/dummy-aks-cluster-name"
      }
    }
  }
}

inputs = {
  aks_cluster_node_pools = { for node_pool in local.config.aks_node_pools : node_pool.name => {

    name                       = node_pool.name
    kubernetes_cluster_id      = lookup(dependency.aks.outputs.aks_clusters_output, node_pool.kubernetes_cluster_name, { id = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/dummy-rg/providers/Microsoft.ContainerService/managedClusters/dummy-aks-cluster-name" }).id
    vm_size                    = node_pool.vm_size
    node_count                 = node_pool.node_count
    auto_scaling_enabled       = node_pool.auto_scaling_enabled
    vnet_subnet_id             = lookup(dependency.subnet.outputs.subnets_output, node_pool.node_pool_subnet_name, { id = null }).id
    max_count                  = node_pool.max_count
    min_count                  = node_pool.min_count
    orchestrator_version       = node_pool.orchestrator_version
    node_taints                = node_pool.node_taints
    os_disk_type               = node_pool.os_disk_type
    zones                      = node_pool.zones
    fips_enabled               = node_pool.fips_enabled
    upgrade_settings_max_surge = node_pool.upgrade_settings.max_surge

    tags = merge(local.common_tags, node_pool.resource_tags)

    }
  }
}