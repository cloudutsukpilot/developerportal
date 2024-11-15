resource "azurerm_kubernetes_cluster_node_pool" "aks_node_pools" {

  for_each = var.aks_cluster_node_pools


  name                  = each.value.name
  kubernetes_cluster_id = each.value.kubernetes_cluster_id
  vm_size               = each.value.vm_size
  node_count            = each.value.node_count
  auto_scaling_enabled  = each.value.auto_scaling_enabled
  vnet_subnet_id        = each.value.vnet_subnet_id
  max_count             = each.value.max_count
  min_count             = each.value.min_count
  orchestrator_version  = each.value.orchestrator_version
  node_taints           = each.value.node_taints
  os_disk_type          = each.value.os_disk_type
  zones                 = each.value.zones
  fips_enabled          = each.value.fips_enabled
  upgrade_settings {
    max_surge = each.value.upgrade_settings_max_surge
  }
  tags = each.value.tags

}
