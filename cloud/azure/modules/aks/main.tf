resource "azurerm_kubernetes_cluster" "main" {
  for_each                            = { for clusters in local.clusters_list : clusters.name => clusters }
  location                            = each.value.location
  name                                = each.value.name
  resource_group_name                 = each.value.rg
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
  #tags                                = each.value.tags
  workload_identity_enabled = each.value.workload_identity_enabled
  #key_vault_key_id                    = data.azurerm_key_vault.vault.id
  default_node_pool {
    name                = each.value.default_node_pool.name
    vm_size             = each.value.default_node_pool.vm_size
    node_count          = each.value.default_node_pool.node_count
    min_count           = each.value.default_node_pool.min_count
    max_count           = each.value.default_node_pool.max_count
    enable_auto_scaling = each.value.default_node_pool.enable_auto_scaling
    orchestrator_version = each.value.default_node_pool.orchestrator_version
    #vnet_subnet_id      = length(local.node_pools) > 0 ? data.azurerm_subnet.node_pool_subnet[each.key].id : data.azurerm_subnet.cluster_subnet[each.key].id
    vnet_subnet_id = data.azurerm_subnet.cluster_subnet["${each.value.vnet}-${each.value.subnet}"].id
    upgrade_settings {
      max_surge = each.value.default_node_pool.max_surge
    }
  }
  identity {

    type = each.value.identity_type

  }

  dynamic "azure_active_directory_role_based_access_control" {
    for_each = each.value.role_based_access_control_enabled && each.value.rbac_aad_managed ? ["rbac"] : []

    content {
      admin_group_object_ids = each.value.rbac_aad_admin_group_object_ids
      azure_rbac_enabled     = each.value.rbac_aad_azure_rbac_enabled
      managed                = true
      # tenant_id              = each.value.rbac_aad_tenant_id
    }
  }



  network_profile {
    network_plugin     = each.value.network_plugin
    dns_service_ip     = each.value.net_profile_dns_service_ip
    load_balancer_sku  = each.value.load_balancer_sku
    network_policy     = each.value.network_policy
    outbound_type      = each.value.net_profile_outbound_type
    pod_cidr           = each.value.net_profile_pod_cidr
    service_cidr       = each.value.net_profile_service_cidr

    dynamic "load_balancer_profile" {
      for_each = each.value.load_balancer_profile_enabled && each.value.load_balancer_sku == "standard" ? ["load_balancer_profile"] : []

      content {
        idle_timeout_in_minutes     = each.value.load_balancer_profile_idle_timeout_in_minutes
        managed_outbound_ip_count   = each.value.load_balancer_profile_managed_outbound_ip_count
        managed_outbound_ipv6_count = each.value.load_balancer_profile_managed_outbound_ipv6_count
        outbound_ip_address_ids     = each.value.load_balancer_profile_outbound_ip_address_ids
        outbound_ip_prefix_ids      = each.value.load_balancer_profile_outbound_ip_prefix_ids
        outbound_ports_allocated    = each.value.load_balancer_profile_outbound_ports_allocated
      }
    }

  }



  tags = local.tags
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

