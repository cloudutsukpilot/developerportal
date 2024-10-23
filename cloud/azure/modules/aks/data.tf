data "azurerm_virtual_network" "node_pool_vnet" {
  for_each            = { for clusters in local.clusters_list : clusters.name => clusters }
  name                = each.value.vnet
  resource_group_name = each.value.rg
}

data "azurerm_subnet" "node_pool_subnet" {
  for_each             = { for node_pool in local.node_pools : "${node_pool.vnet}-${node_pool.subnet}" => node_pool }
  name                 = each.value.subnet
  virtual_network_name = each.value.vnet
  resource_group_name  = each.value.rg
  //subnet_name          = each.value.subnet_name
}


# data "azurerm_container_registry" "acr" {
#   name                = var.global.acr_name
#   resource_group_name = var.global.acr_rg_name
# }

data "azurerm_subnet" "cluster_subnet" {
  for_each             = { for clusters in local.clusters_list : "${clusters.vnet}-${clusters.subnet}" => clusters }
  name                 = each.value.subnet
  virtual_network_name = each.value.vnet
  resource_group_name  = each.value.rg
  //subnet_name          = each.value.subnet_name
}

data "azurerm_client_config" "current" {}

data "azurerm_subscription" "primary" {
}

data "azurerm_role_definition" "AKSClusterAdmin" {
  name  = "Azure Kubernetes Service RBAC Cluster Admin"
  scope = data.azurerm_subscription.primary.id
}

# data "azurerm_resource_group" "Cluster_RG" {
#   name = try(var.aks_cluster.resource_group_name, "${var.global.environment}-${var.global.application}")
# }

