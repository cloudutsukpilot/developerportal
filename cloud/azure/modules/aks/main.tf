resource "azurerm_kubernetes_cluster" "aks_clusters" {

  for_each                            = var.aks_clusters

  name                                = each.value.name
  location                            = each.value.location
  resource_group_name                 = each.value.resource_group_name
  azure_policy_enabled                = each.value.azure_policy_enabled
  dns_prefix                          = each.value.dns_prefix
  kubernetes_version                  = each.value.kubernetes_version
  local_account_disabled              = each.value.local_account_disabled
  node_resource_group                 = each.value.node_resource_group
  oidc_issuer_enabled                 = each.value.oidc_issuer_enabled
  private_cluster_enabled             = each.value.private_cluster_enabled
  private_cluster_public_fqdn_enabled = each.value.private_cluster_public_fqdn_enabled
  role_based_access_control_enabled   = each.value.role_based_access_control_enabled
  sku_tier                            = each.value.sku_tier
  tags                                = each.value.tags
  workload_identity_enabled = each.value.workload_identity_enabled
  #key_vault_key_id                    = data.azurerm_key_vault.vault.id

  default_node_pool {
    name                = each.value.default_node_pool_name
    vm_size             = each.value.default_node_pool_vm_size
    node_count          = each.value.default_node_pool_node_count
    
    auto_scaling_enabled = each.value.default_node_pool_enable_auto_scaling
    type                 = each.value.default_node_pool_type
    min_count            = each.value.default_node_pool_min_count
    max_count            = each.value.default_node_pool_max_count
    
    orchestrator_version = each.value.default_node_pool_orchestrator_version
    #vnet_subnet_id      = length(local.node_pools) > 0 ? data.azurerm_subnet.node_pool_subnet[each.key].id : data.azurerm_subnet.cluster_subnet[each.key].id
    vnet_subnet_id = each.value.default_node_pool_vnet_subnet_id
    upgrade_settings {
      max_surge = each.value.default_node_pool_upgrade_settings_max_surge
    }
  }
  identity {

    type = each.value.identity_type

  }

  network_profile {
    network_policy      = each.value.network_profile_network_policy
    network_plugin      = each.value.network_profile_network_plugin
    network_plugin_mode = each.value.network_profile_network_plugin_mode
    network_data_plane  = each.value.network_profile_network_data_plane
    load_balancer_sku   = each.value.network_profile_load_balancer_sku
    outbound_type       = each.value.network_profile_outbound_type
    pod_cidr            = each.value.network_profile_pod_cidr
    service_cidr        = each.value.network_profile_service_cidr
    dns_service_ip      = each.value.network_profile_dns_service_ip
  }
}

# # ACR Role assignment
# resource "azurerm_role_assignment" "role_acrpull" {
#   for_each                         = { for clusters in local.clusters_list : clusters.name => clusters }
#   scope                            = data.azurerm_container_registry.acr.id
#   role_definition_name             = "AcrPull"
#   principal_id                     = azurerm_kubernetes_cluster.main[each.key].kubelet_identity[0].object_id
#   skip_service_principal_aad_check = true
# }

# # Role assignment to Vnet
# resource "azurerm_role_assignment" "network_contributor_for_aks" {
#   for_each                         = { for clusters in local.clusters_list : clusters.name => clusters }
#   scope                            = data.azurerm_virtual_network.node_pool_vnet[each.value.name].id
#   role_definition_name             = "Network Contributor"
#   principal_id                     = azurerm_kubernetes_cluster.main[each.value.name].identity[0].principal_id
#   skip_service_principal_aad_check = true
# }

# resource "azurerm_role_assignment" "AKS_CLuster_Admin_Assignment" {
#   for_each     = { for k,v in local.role_assignment_list: "${v.clustername}-${v.objectid}" => v}
#   scope              = azurerm_kubernetes_cluster.main[each.value.clustername].id
#   role_definition_id = data.azurerm_role_definition.AKSClusterAdmin.id
#   principal_id       = each.value.objectid
# }

