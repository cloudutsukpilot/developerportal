resource "azurerm_kubernetes_cluster_node_pool" "nodepools" {
  for_each              = { for nodepool, nodepool_data in local.node_pools : "${nodepool_data.cluster}-${nodepool_data.name}" => nodepool_data }
  name                  = each.value.name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main["${each.value.cluster}"].id
  vm_size               = each.value.vm_size
  node_count            = each.value.node_count
  max_pods              = each.value.max_pods
  node_labels           = each.value.node_labels
  enable_auto_scaling   = each.value.enable_auto_scaling
  vnet_subnet_id        = data.azurerm_subnet.node_pool_subnet["${each.value.vnet}-${each.value.subnet}"].id
  max_count             = each.value.enable_auto_scaling ? each.value.max_count : 0
  min_count             = each.value.enable_auto_scaling ? each.value.min_count : 0
  orchestrator_version  = each.value.orchestrator_version
  node_taints           = each.value.node_taints
  os_disk_type          = each.value.os_disk_type
  zones                 = each.value.zones
  fips_enabled          = each.value.fips_enabled
  upgrade_settings {
    max_surge = each.value.max_surge
  }
  # tags                      = merge(local.default_tags, var.custom_tags)
}