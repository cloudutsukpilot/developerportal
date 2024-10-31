locals {
  config      = yamldecode(file(find_in_parent_folders("config.yaml")))
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env_name    = local.env_vars.locals.env
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
  common_tags = local.common_vars.common_tags
}

terraform {
  source = "../../../../../cloud/azure/modules/aks"
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

dependency "log_analytics_workspace" {
  config_path                             = "${get_terragrunt_dir()}/../log_analytics_workspace"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "apply", "destroy", "output"]
  skip_outputs                            = true
}

inputs = {
  aks_clusters = { for cluster in local.config.aks_clusters : cluster.name => {
    name                                = cluster.name
    location                            = cluster.location
    resource_group_name                 = cluster.resource_group_name
    azure_policy_enabled                = cluster.azure_policy_enabled
    dns_prefix                          = cluster.dns_prefix
    kubernetes_version                  = cluster.kubernetes_version
    local_account_disabled              = cluster.local_account_disabled
    node_resource_group                 = cluster.node_resource_group
    oidc_issuer_enabled                 = cluster.oidc_issuer_enabled
    private_cluster_enabled             = cluster.private_cluster_enabled
    private_cluster_public_fqdn_enabled = cluster.private_cluster_public_fqdn_enabled
    role_based_access_control_enabled   = cluster.role_based_access_control_enabled
    sku_tier                            = cluster.sku_tier
    tags                                = merge(local.common_tags, cluster.resource_tags)
    workload_identity_enabled           = cluster.workload_identity_enabled
    vnet_subnet_id                      = cluster.vnet_subnet_id

    default_node_pool_name                       = cluster.default_node_pool.name
    default_node_pool_vm_size                    = cluster.default_node_pool.vm_size
    default_node_pool_node_count                 = cluster.default_node_pool.node_count
    default_node_pool_min_count                  = cluster.default_node_pool.min_count
    default_node_pool_max_count                  = cluster.default_node_pool.max_count
    default_node_pool_enable_auto_scaling        = cluster.default_node_pool.enable_auto_scaling
    default_node_pool_type                       = cluster.default_node_pool.type
    default_node_pool_orchestrator_version       = cluster.default_node_pool.orchestrator_version
    default_node_pool_vnet_subnet_id             = cluster.default_node_pool.vnet_subnet_id
    default_node_pool_upgrade_settings_max_surge = cluster.default_node_pool.upgrade_settings.max_surge

    identity_type = cluster.identity.type

    network_profile_network_policy      = cluster.network_profile.network_policy
    network_profile_network_plugin      = cluster.network_profile.network_plugin
    network_profile_network_plugin_mode = cluster.network_profile.network_plugin_mode
    network_profile_network_data_plane  = cluster.network_profile.network_data_plane
    network_profile_load_balancer_sku   = cluster.network_profile.load_balancer_sku
    network_profile_outbound_type       = cluster.network_profile.outbound_type
    network_profile_pod_cidr            = cluster.network_profile.pod_cidr
    network_profile_service_cidr        = cluster.network_profile.service_cidr
    network_profile_dns_service_ip      = cluster.network_profile.dns_service_ip
    }
  }
}